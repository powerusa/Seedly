import Foundation

// MET Norway Locationforecast 2.0, CC BY 4.0. The nearest forecast timestep
// represents current conditions; it is not a reading from the phone's sensors.
enum METWeatherProvider {
    struct Payload: Decodable {
        let properties: Properties
        struct Properties: Decodable { let meta: Meta; let timeseries: [Sample] }
        struct Meta: Decodable {
            let updatedAt: Date
            enum CodingKeys: String, CodingKey { case updatedAt = "updated_at" }
        }
        struct Sample: Decodable {
            let time: Date
            let data: Values
        }
        struct Values: Decodable {
            let instant: Instant
            let next1Hours: Period?
            let next6Hours: Period?
            let next12Hours: Period?
            enum CodingKeys: String, CodingKey {
                case instant
                case next1Hours = "next_1_hours", next6Hours = "next_6_hours", next12Hours = "next_12_hours"
            }
        }
        struct Instant: Decodable { let details: Details }
        struct Details: Decodable {
            let airTemperature: Double
            let apparentAirTemperature: Double?
            let relativeHumidity: Double
            let windSpeed: Double
            let cloudAreaFraction: Double
            let ultravioletIndexClearSky: Double?
            enum CodingKeys: String, CodingKey {
                case airTemperature = "air_temperature", apparentAirTemperature = "apparent_air_temperature"
                case relativeHumidity = "relative_humidity", windSpeed = "wind_speed"
                case cloudAreaFraction = "cloud_area_fraction"
                case ultravioletIndexClearSky = "ultraviolet_index_clear_sky"
            }
        }
        struct Period: Decodable {
            let summary: Summary
            let details: PeriodDetails
        }
        struct Summary: Decodable {
            let symbolCode: String
            enum CodingKeys: String, CodingKey { case symbolCode = "symbol_code" }
        }
        struct PeriodDetails: Decodable {
            let precipitationAmount: Double?
            let probabilityOfPrecipitation: Double?
            let airTemperatureMax: Double?
            let airTemperatureMin: Double?
            enum CodingKeys: String, CodingKey {
                case precipitationAmount = "precipitation_amount"
                case probabilityOfPrecipitation = "probability_of_precipitation"
                case airTemperatureMax = "air_temperature_max", airTemperatureMin = "air_temperature_min"
            }
        }
    }

    enum ProviderError: Error { case invalidCoordinates, invalidResponse, staleForecast, incompleteForecast }

    static func request(for location: GardenLocation) throws -> URLRequest {
        guard location.latitude.isFinite, location.longitude.isFinite,
              (-90...90).contains(location.latitude), (-180...180).contains(location.longitude) else {
            throw ProviderError.invalidCoordinates
        }
        var components = URLComponents(string: "https://api.met.no/weatherapi/locationforecast/2.0/complete")!
        let locale = Locale(identifier: "en_US_POSIX")
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(format: "%.4f", locale: locale, location.latitude)),
            URLQueryItem(name: "lon", value: String(format: "%.4f", locale: locale, location.longitude))
        ]
        var request = URLRequest(url: components.url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 20)
        request.setValue("Seedly/3.0 github.com/powerusa/Seedly", forHTTPHeaderField: "User-Agent")
        return request
    }

    static func decode(_ data: Data, location: GardenLocation, now: Date = Date()) throws -> WeatherData {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let payload = try decoder.decode(Payload.self, from: data)
        let properties = payload.properties
        guard now.timeIntervalSince(properties.meta.updatedAt) < 24 * 3600,
              properties.meta.updatedAt.timeIntervalSince(now) < 3600 else { throw ProviderError.staleForecast }
        let samples = properties.timeseries.sorted { $0.time < $1.time }
        guard let current = samples.last(where: { $0.time <= now }) ?? samples.first,
              abs(current.time.timeIntervalSince(now)) < 3 * 3600 else { throw ProviderError.staleForecast }
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = location.timeZone
        let today = calendar.startOfDay(for: now)
        let groups = Dictionary(grouping: samples.filter { $0.time >= today }, by: { calendar.startOfDay(for: $0.time) })
        let days = groups.keys.sorted().prefix(7)
        var forecast: [DayForecast] = []
        for day in days {
            let values = groups[day]!.sorted { $0.time < $1.time }
            guard !values.isEmpty else { continue }
            let instant = values.map { $0.data.instant.details }
            // Interval max/min supplement sparse (six-hour) medium-range samples.
            let highs = instant.map(\.airTemperature) + values.compactMap { $0.data.next6Hours?.details.airTemperatureMax }
            let lows = instant.map(\.airTemperature) + values.compactMap { $0.data.next6Hours?.details.airTemperatureMin }
            // Pick the shortest supplied interval and never count a six-hour total
            // again inside the following one-hour periods.
            var coveredUntil = day
            var rain = 0.0
            for sample in values where sample.time >= coveredUntil {
                let hours = sample.data.next1Hours != nil ? 1 : 6
                let period = sample.data.next1Hours ?? sample.data.next6Hours
                if let mm = period?.details.precipitationAmount {
                    rain += mm
                    coveredUntil = sample.time.addingTimeInterval(Double(hours) * 3600)
                }
            }
            let representative = values.min {
                abs(calendar.component(.hour, from: $0.time) - 12) < abs(calendar.component(.hour, from: $1.time) - 12)
            }!
            let period = representative.data.next1Hours ?? representative.data.next6Hours ?? representative.data.next12Hours
            let code = period?.summary.symbolCode
            let condition = code.map(condition(for:)) ?? cloudCondition(representative)
            let uv = instant.compactMap(\.ultravioletIndexClearSky).max().map { Int($0.rounded(.up)) }
            let probability = values.compactMap { ($0.data.next1Hours ?? $0.data.next6Hours)?.details.probabilityOfPrecipitation }.max()
            forecast.append(DayForecast(date: day, highTemp: highs.max()!, lowTemp: lows.min()!, condition: condition,
                                        precipitationMm: rain, precipitationChance: probability.map { Int($0.rounded()) },
                                        humidity: Int((instant.map(\.relativeHumidity).reduce(0, +) / Double(instant.count)).rounded()),
                                        windSpeedKmh: (instant.map(\.windSpeed).max() ?? 0) * 3.6, uvIndex: uv))
        }
        guard let first = forecast.first, calendar.isDate(first.date, inSameDayAs: now) else {
            throw ProviderError.incompleteForecast
        }
        let details = current.data.instant.details
        let currentPeriod = current.data.next1Hours ?? current.data.next6Hours ?? current.data.next12Hours
        let currentCondition = currentPeriod.map { condition(for: $0.summary.symbolCode) } ?? cloudCondition(current)
        return WeatherData(location: location.city, currentTemp: details.airTemperature, feelsLike: details.apparentAirTemperature,
                           highTemp: first.highTemp, lowTemp: first.lowTemp, humidity: Int(details.relativeHumidity.rounded()),
                           windSpeedKmh: details.windSpeed * 3.6, uvIndex: details.ultravioletIndexClearSky.map { Int($0.rounded(.up)) },
                           condition: currentCondition, precipitationMm: first.precipitationMm,
                           precipitationChance: first.precipitationChance, sunrise: nil, sunset: nil,
                           forecast: forecast, lastUpdated: properties.meta.updatedAt)
    }

    private static func cloudCondition(_ sample: Payload.Sample) -> WeatherCondition {
        switch sample.data.instant.details.cloudAreaFraction {
        case 90...: return .overcast
        case 60..<90: return .cloudy
        case 15..<60: return .partlyCloudy
        default: return .sunny
        }
    }

    static func condition(for symbol: String) -> WeatherCondition {
        let symbol = symbol.lowercased()
        if symbol.contains("thunder") { return .thunderstorm }
        if symbol.contains("sleet") { return .sleet }
        if symbol.contains("snow") { return .snow }
        if symbol.contains("heavyrain") { return .heavyRain }
        if symbol.contains("lightrain") { return .lightRain }
        if symbol.contains("rain") { return .rain }
        if symbol.contains("fog") { return .fog }
        if symbol.contains("clearsky") { return .sunny }
        if symbol.contains("fair") { return .partlyCloudy }
        if symbol.contains("partlycloudy") { return .partlyCloudy }
        return .cloudy
    }
}
