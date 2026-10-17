import Foundation
import CoreLocation

@MainActor
final class LocationService: NSObject, ObservableObject {
    static let shared = LocationService()
    @Published private(set) var currentLocation: GardenLocation?
    @Published private(set) var usesManualLocation = false
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var isLoading = false
    @Published var error: LocationError?

    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    private var requestToken = UUID()
    private let savedKey = "location.saved.v1"
    private let manualKey = "location.manual.v1"

    private override init() {
        super.init()
        if let data = UserDefaults.standard.data(forKey: savedKey) {
            currentLocation = try? JSONDecoder().decode(GardenLocation.self, from: data)
        }
        usesManualLocation = currentLocation != nil && UserDefaults.standard.bool(forKey: manualKey)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        authorizationStatus = locationManager.authorizationStatus
    }

    func requestPermission() { useDeviceLocation() }

    func useDeviceLocation() {
        requestToken = UUID()
        usesManualLocation = false
        UserDefaults.standard.set(false, forKey: manualKey)
        refreshCurrentLocation()
    }

    func refreshCurrentLocation() {
        guard !usesManualLocation else { return }
        authorizationStatus = locationManager.authorizationStatus
        switch authorizationStatus {
        case .notDetermined:
            isLoading = true
            error = nil
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            requestLocation()
        case .denied, .restricted:
            isLoading = false
            error = .permissionDenied
        @unknown default:
            isLoading = false
            error = .locationUnavailable
        }
    }

    func requestLocation() {
        guard !usesManualLocation else { return }
        isLoading = true
        error = nil
        locationManager.requestLocation()
    }

    func setManualCity(_ query: String) async {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { error = .geocodingFailed; return }
        let token = UUID()
        requestToken = token
        geocoder.cancelGeocode()
        isLoading = true
        error = nil
        defer { if requestToken == token { isLoading = false } }
        do {
            let places = try await geocoder.geocodeAddressString(query, in: nil, preferredLocale: selectedLocale)
            guard requestToken == token else { return }
            guard let place = places.first, let location = place.location else {
                error = .geocodingFailed
                return
            }
            save(Self.resolve(location, placemark: place), manual: true)
        } catch {
            if requestToken == token { self.error = .geocodingFailed }
        }
    }

    func setManualLocation(latitude: Double, longitude: Double) async {
        guard CLLocationCoordinate2DIsValid(CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) else {
            error = .locationUnavailable
            return
        }
        let token = UUID()
        requestToken = token
        geocoder.cancelGeocode()
        isLoading = true
        error = nil
        defer { if requestToken == token { isLoading = false } }
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let places = try? await geocoder.reverseGeocodeLocation(location, preferredLocale: selectedLocale)
        guard requestToken == token else { return }
        save(Self.resolve(location, placemark: places?.first), manual: true)
    }

    private var selectedLocale: Locale {
        Locale(identifier: UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en")
    }

    private func save(_ location: GardenLocation, manual: Bool) {
        usesManualLocation = manual
        UserDefaults.standard.set(manual, forKey: manualKey)
        if let data = try? JSONEncoder().encode(location) {
            UserDefaults.standard.set(data, forKey: savedKey)
        }
        error = nil
        currentLocation = location
    }

    static func resolve(_ location: CLLocation, placemark: CLPlacemark?) -> GardenLocation {
        GardenLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude,
                       city: placemark?.locality ?? placemark?.administrativeArea
                           ?? String(format: "%.4f, %.4f", location.coordinate.latitude, location.coordinate.longitude),
                       country: placemark?.country ?? "", timeZone: placemark?.timeZone ?? .current)
    }

    private func processLocation(_ location: CLLocation) async {
        guard !usesManualLocation else { return }
        let token = requestToken
        let places = try? await geocoder.reverseGeocodeLocation(location, preferredLocale: selectedLocale)
        guard requestToken == token, !usesManualLocation else { return }
        // Coordinates remain useful even when reverse geocoding returns no placemarks.
        save(Self.resolve(location, placemark: places?.first), manual: false)
        isLoading = false
    }
}

extension LocationService: CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        Task { @MainActor in await self.processLocation(location) }
    }
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            guard !self.usesManualLocation else { return }
            self.isLoading = false
            self.error = .locationUnavailable
        }
    }
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            self.authorizationStatus = status
            guard !self.usesManualLocation else { return }
            switch status {
            case .authorizedAlways, .authorizedWhenInUse: self.requestLocation()
            case .denied, .restricted:
                self.isLoading = false
                self.error = .permissionDenied
            default: break
            }
        }
    }
}

enum LocationError: Error, LocalizedError {
    case permissionDenied, locationUnavailable, geocodingFailed
    var errorDescription: String? {
        let pl = UserDefaults.standard.string(forKey: "selectedLanguage") == "pl"
        switch self {
        case .permissionDenied: return pl ? "Brak zgody na lokalizację. Włącz ją w Ustawieniach lub wpisz miasto ręcznie." : "Location permission denied. Enable it in Settings or enter your city manually."
        case .locationUnavailable: return pl ? "Nie można ustalić lokalizacji. Spróbuj ponownie lub wpisz miasto." : "Unable to determine location. Try again or enter your city."
        case .geocodingFailed: return pl ? "Nie znaleziono miasta. Podaj miasto i kraj; sprawdź połączenie z internetem." : "City not found. Enter a city and country and check your internet connection."
        }
    }
}
