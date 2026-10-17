import Foundation

actor WeatherService {
    static let shared = WeatherService()
    private let session: URLSession
    init(session: URLSession = .shared) { self.session = session }
    private struct Entry { let weather: WeatherData; let expires: Date }
    private var cache: [String: Entry] = [:]
    private var inFlight: [String: Task<Entry?, Never>] = [:]
    private var retryAfter: [String: Date] = [:]

    func fetchWeather(for location: GardenLocation) async -> WeatherData? {
        guard let request = try? METWeatherProvider.request(for: location), let key = request.url?.absoluteString else { return nil }
        if let entry = cache[key], entry.expires > Date() { return entry.weather }
        if let pending = inFlight[key] { return await pending.value?.weather }
        if let until = retryAfter[key], until > Date() { return nil }
        let pending = Task<Entry?, Never> {
            do {
                let (data, response) = try await session.data(for: request)
                guard let response = response as? HTTPURLResponse else { return nil }
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.timeZone = TimeZone(secondsFromGMT: 0)
                formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
                guard (200...299).contains(response.statusCode) else {
                    let delay = response.value(forHTTPHeaderField: "Retry-After").flatMap { Double($0) ?? formatter.date(from: $0)?.timeIntervalSinceNow }
                    retryAfter[key] = Date().addingTimeInterval(max(delay ?? (response.statusCode == 429 ? 900 : 60), 60))
                    return nil
                }
                let weather = try METWeatherProvider.decode(data, location: location)
                let expires = response.value(forHTTPHeaderField: "Expires").flatMap { formatter.date(from: $0) }
                    ?? Date().addingTimeInterval(30 * 60)
                return Entry(weather: weather, expires: max(expires, Date().addingTimeInterval(60)))
            } catch {
                return nil
            }
        }
        inFlight[key] = pending
        let entry = await pending.value
        inFlight[key] = nil
        if let entry {
            cache[key] = entry
            retryAfter[key] = nil
            if cache.count > 16 {
                for oldKey in cache.keys.sorted() where oldKey != key {
                    cache[oldKey] = nil
                    if cache.count <= 16 { break }
                }
            }
            return entry.weather
        }
        // Avoid repeat requests during network failures or service throttling.
        retryAfter[key] = retryAfter[key] ?? Date().addingTimeInterval(60)
        return nil
    }

    // MARK: - Generate Insights
    nonisolated func generateInsights(weather: WeatherData, plants: [Plant]) -> [GardenInsight] {
        let language = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "en"
        let bundle = Bundle.main.path(forResource: language, ofType: "lproj").flatMap(Bundle.init(path:)) ?? .main
        func localized(_ key: String) -> String { bundle.localizedString(forKey: key, value: nil, table: nil) }
        var insights: [GardenInsight] = []
        
        // Frost alert
        if weather.hasFrostRisk {
            insights.append(GardenInsight(
                type: .frost,
                title: localized("insight_frost_title"),
                subtitle: localized("insight_frost_subtitle"),
                icon: "thermometer.snowflake",
                priority: 1,
                actionable: true
            ))
        }
        
        // Heat alert
        if weather.hasHeatRisk {
            insights.append(GardenInsight(
                type: .heat,
                title: localized("insight_heat_title"),
                subtitle: localized("insight_heat_subtitle"),
                icon: "thermometer.sun.fill",
                priority: 1,
                actionable: true
            ))
        }
        
        // Rain insight
        if weather.hasRainExpected {
            insights.append(GardenInsight(
                type: .rain,
                title: localized("insight_rain_title"),
                subtitle: localized("insight_rain_subtitle"),
                icon: "cloud.rain.fill",
                priority: 2,
                actionable: false
            ))
        }
        
        // Planting conditions
        if !weather.hasFrostRisk && !weather.hasHeatRisk && weather.currentTemp >= 15 && weather.lowTemp >= 10 && weather.condition.gardeningImpact == .excellent {
            insights.append(GardenInsight(
                type: .planting,
                title: localized("insight_perfect_title"),
                subtitle: localized("insight_perfect_subtitle"),
                icon: "leaf.fill",
                priority: 3,
                actionable: true
            ))
        }
        
        // Watering insight
        if !weather.hasRainExpected && weather.humidity < 40 {
            insights.append(GardenInsight(
                type: .watering,
                title: localized("insight_water_title"),
                subtitle: localized("insight_water_subtitle"),
                icon: "drop.fill",
                priority: 3,
                actionable: true
            ))
        }
        
        // Wind warning
        if weather.windSpeedKmh > 40 {
            insights.append(GardenInsight(
                type: .wind,
                title: localized("insight_wind_title"),
                subtitle: localized("insight_wind_subtitle"),
                icon: "wind",
                priority: 2,
                actionable: true
            ))
        }
        
        return insights.sorted { $0.priority < $1.priority }
    }
    
}
