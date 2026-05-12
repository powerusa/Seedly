// LocationService.swift
// Seedly

import Foundation
import CoreLocation

@MainActor
final class LocationService: NSObject, ObservableObject {
    @Published var currentLocation: GardenLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var isLoading = false
    @Published var error: LocationError?
    
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        isLoading = true
        error = nil
        locationManager.requestLocation()
    }
    
    func setManualLocation(latitude: Double, longitude: Double) async {
        isLoading = true
        defer { isLoading = false }
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                currentLocation = GardenLocation(
                    latitude: latitude,
                    longitude: longitude,
                    city: placemark.locality ?? "Unknown",
                    country: placemark.country ?? "Unknown",
                    timeZone: placemark.timeZone ?? .current
                )
            }
        } catch {
            // Fallback without geocoding
            currentLocation = GardenLocation(
                latitude: latitude,
                longitude: longitude,
                city: "Unknown",
                country: "Unknown",
                timeZone: .current
            )
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationService: @preconcurrency CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        Task { @MainActor in
            await self.processLocation(location)
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.isLoading = false
            self.error = .locationUnavailable
        }
    }
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            self.authorizationStatus = manager.authorizationStatus
            
            if manager.authorizationStatus == .authorizedWhenInUse ||
               manager.authorizationStatus == .authorizedAlways {
                self.requestLocation()
            }
        }
    }
    
    @MainActor
    private func processLocation(_ location: CLLocation) async {
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                currentLocation = GardenLocation(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude,
                    city: placemark.locality ?? "Unknown",
                    country: placemark.country ?? "Unknown",
                    timeZone: placemark.timeZone ?? .current
                )
            }
        } catch {
            currentLocation = GardenLocation(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude,
                city: "Unknown",
                country: "Unknown",
                timeZone: .current
            )
        }
        isLoading = false
    }
}

enum LocationError: Error, LocalizedError {
    case permissionDenied
    case locationUnavailable
    case geocodingFailed
    
    var errorDescription: String? {
        switch self {
        case .permissionDenied: return "Location permission denied"
        case .locationUnavailable: return "Unable to determine location"
        case .geocodingFailed: return "Unable to determine city name"
        }
    }
}
