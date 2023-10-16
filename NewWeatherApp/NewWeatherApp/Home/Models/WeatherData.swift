//
//  WeatherData.swift
//  NewWeatherApp
//
//  Created by Arun on 28/09/23.
//

import Foundation

// MARK: - WeatherData
struct WeatherDataResponse: Codable {
    let latitude, longitude, generationtimeMS: Double?
    let utcOffsetSeconds: Int?
    let timezone, timezoneAbbreviation: String?
    let elevation: Int?
    let currentWeather: CurrentWeather?
    let currentWeatherUnits: CurrentWeatherUnits?

    enum CodingKeys: String, CodingKey {
        case latitude, longitude
        case generationtimeMS = "generationtime_ms"
        case utcOffsetSeconds = "utc_offset_seconds"
        case timezone
        case timezoneAbbreviation = "timezone_abbreviation"
        case elevation
        case currentWeather = "current_weather"
        case currentWeatherUnits = "current_weather_units"

    }
    
  
}

// MARK: - CurrentWeather
struct CurrentWeather: Codable {
    let temperature, windspeed: Double?
    let winddirection, weathercode: Int?
    let time: String?
    
   
}
struct CurrentWeatherUnits: Codable {
    let time, temperature, windspeed, winddirection: String?
    let isDay, weathercode: String?

    enum CodingKeys: String, CodingKey {
        case time, temperature, windspeed, winddirection
        case isDay = "is_day"
        case weathercode
    }
   
}
#if !RELEASE

extension CurrentWeather : Fakeable {
    static var defaultFakeValue : CurrentWeather {
        CurrentWeather.fake()
    }
    
    public static func fake(temperature: Double? = .fake(), windspeed: Double? = .fake(), winddirection: Int? = .fake(), weathercode: Int? = .fake(), time: String? = .fake()) -> CurrentWeather {
        CurrentWeather(temperature: temperature, windspeed: windspeed, winddirection: winddirection, weathercode: weathercode, time: time)
    }
}

extension CurrentWeatherUnits : Fakeable {
    
    static var defaultFakeValue: CurrentWeatherUnits {
        CurrentWeatherUnits.fake()
    }
    public static func fake(time: String? = .fake(), temperature: String? = .fake(), windspeed: String? = .fake(), winddirection: String? = .fake(), isDay: String? = .fake(), weathercode: String? = .fake())  -> CurrentWeatherUnits{
      CurrentWeatherUnits(time: time, temperature: temperature, windspeed: windspeed, winddirection: winddirection, isDay: isDay, weathercode: weathercode)
    }
}
extension WeatherDataResponse:Fakeable{
    static var defaultFakeValue: WeatherDataResponse {
        WeatherDataResponse.fake()
    }
    
    public static func fake(latitude: Double? = .fake(), longitude: Double? = .fake(), generationtimeMS: Double? = .fake(), utcOffsetSeconds: Int? = .fake(), timezone: String? = .fake(), timezoneAbbreviation: String? = .fake(), elevation: Int? = .fake(), currentWeather: CurrentWeather? = .fake(), currentWeatherUnits: CurrentWeatherUnits? = .fake()) -> WeatherDataResponse {
        
       WeatherDataResponse(latitude: latitude, longitude: longitude, generationtimeMS: generationtimeMS, utcOffsetSeconds: utcOffsetSeconds, timezone: timezone, timezoneAbbreviation: timezoneAbbreviation, elevation: elevation, currentWeather: currentWeather, currentWeatherUnits: currentWeatherUnits)
    }
    
}


#endif
