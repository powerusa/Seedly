import Foundation

struct WeatherChecks {
    static func run() async throws {
        let location = GardenLocation(latitude: 50.0594739, longitude: 19.9361936, city: "Krakow", country: "Poland", timeZone: TimeZone(identifier: "Europe/Warsaw")!)
        let data = try Data(contentsOf: URL(fileURLWithPath: "Checks/Fixtures/met-krakow.json"))
        let reference = ISO8601DateFormatter().date(from: "2026-10-17T12:15:00Z")!
        let weather = try METWeatherProvider.decode(data, location: location, now: reference)
        assert(abs(weather.currentTemp - 12.8) < 0.001)
        assert(abs(weather.windSpeedKmh - 7.56) < 0.001, "Convert m/s to km/h")
        assert(weather.forecast.count == 7)
        assert(weather.forecast.allSatisfy { $0.highTemp >= $0.lowTemp })
        assert(weather.precipitationChance == nil && weather.sunrise == nil, "Missing fields must not become invented values")
        assert(weather.condition == .sunny)
        let insights = WeatherService.shared.generateInsights(weather: weather, plants: [])
        assert(!insights.contains { $0.type == .planting }, "A sunny but cold forecast must not claim ideal planting conditions")
        let request = try METWeatherProvider.request(for: location)
        assert(request.url!.query!.contains("lat=50.0595") && request.url!.query!.contains("lon=19.9362"))
        assert(request.value(forHTTPHeaderField: "User-Agent")!.contains("powerusa/Seedly"))
        do {
            _ = try METWeatherProvider.decode(data, location: location, now: reference.addingTimeInterval(2 * 86400))
            fatalError("Stale model must be rejected")
        } catch METWeatherProvider.ProviderError.staleForecast { }
        for (symbol, expected) in [("heavyrainandthunder", WeatherCondition.thunderstorm), ("sleetshowers_day", .sleet), ("heavysnow", .snow), ("partlycloudy_night", .partlyCloudy)] {
            assert(METWeatherProvider.condition(for: symbol) == expected)
        }
        // Move the fixture timestamps together so the real network service can be
        // exercised deterministically without making requests to the live provider.
        let formatter = ISO8601DateFormatter()
        var payload = try JSONSerialization.jsonObject(with: data) as! [String: Any]
        var properties = payload["properties"] as! [String: Any]
        var meta = properties["meta"] as! [String: Any]
        let shift = Date().timeIntervalSince(reference)
        meta["updated_at"] = formatter.string(from: formatter.date(from: meta["updated_at"] as! String)!.addingTimeInterval(shift))
        properties["meta"] = meta
        var times = properties["timeseries"] as! [[String: Any]]
        for i in times.indices {
            times[i]["time"] = formatter.string(from: formatter.date(from: times[i]["time"] as! String)!.addingTimeInterval(shift))
        }
        properties["timeseries"] = times; payload["properties"] = properties
        WeatherStub.state.configure(data: try JSONSerialization.data(withJSONObject: payload), status: 200)
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [WeatherStub.self]
        let session = URLSession(configuration: configuration)
        defer { session.invalidateAndCancel() }
        let service = WeatherService(session: session)
        async let first = service.fetchWeather(for: location)
        async let second = service.fetchWeather(for: location)
        let results = await (first, second)
        assert(results.0 != nil && results.1 != nil)
        assert(WeatherStub.state.count == 1, "Concurrent views must share one request")
        _ = await service.fetchWeather(for: location)
        assert(WeatherStub.state.count == 1, "Cached forecast must respect Expires")
        let other = GardenLocation(latitude: 52.2297, longitude: 21.0122, city: "Warsaw", country: "Poland", timeZone: location.timeZone)
        _ = await service.fetchWeather(for: other)
        assert(WeatherStub.state.count == 2, "Different locations need separate forecasts")
        WeatherStub.state.configure(data: Data(), status: 429)
        let limited = WeatherService(session: session)
        let failure = await limited.fetchWeather(for: other)
        assert(failure == nil)
        _ = await limited.fetchWeather(for: other)
        assert(WeatherStub.state.count == 1, "Respect provider throttling instead of repeating requests")
        print("PASS: real MET fixture, units, 7 local days, missing fields, stale data, symbol mapping, rounding, shared request/cache, 429 backoff")
    }
}

private final class StubState: @unchecked Sendable {
    private let lock = NSLock()
    private var data = Data()
    private var status = 200
    private var requests = 0
    var count: Int { lock.lock(); defer { lock.unlock() }; return requests }
    func configure(data: Data, status: Int) { lock.lock(); defer { lock.unlock() }; self.data = data; self.status = status; requests = 0 }
    func respond() -> (Data, Int) { lock.lock(); defer { lock.unlock() }; requests += 1; return (data, status) }
}
private final class WeatherStub: URLProtocol, @unchecked Sendable {
    static let state = StubState()
    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        let (data, status) = Self.state.respond()
        let formatter = DateFormatter(); formatter.locale = Locale(identifier: "en_US_POSIX"); formatter.timeZone = TimeZone(secondsFromGMT: 0); formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        let response = HTTPURLResponse(url: request.url!, statusCode: status, httpVersion: nil,
             headerFields: ["Content-Type": "application/json", "Expires": formatter.string(from: Date().addingTimeInterval(3600)), "Retry-After": "900"])!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() { }
}
