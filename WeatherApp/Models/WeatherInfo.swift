//
//  WeatherInfo.swift
//  WeatherApp
//
//  Created by Zhansaya Ayazbayeva on 2021-02-24.
//

import Foundation

struct WeatherInfo: Identifiable, Codable {
    var id: Int
    var cityName: String
    var country: String
    var coord: CityCoordinates
    var timezone_offset: Int
    var current: CurrentWeather
    var hourly: [CurrentWeather]
    var daily: [DailyWeather]
}

struct Weather: Codable, Hashable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Temperature: Codable, Hashable {
    var day: Double
    var eve: Double
    var max: Double
    var min: Double
    var morn: Double
    var night: Double
}

struct Wind: Codable, Hashable {
    var speed: Int
    var deg: Int
}

struct WeatherInfoByCoord {
    init() {
        self.lat = 0.0
        self.lon = 0.0
        self.timezone_offset = 0
    }
    var lat: Double
    var lon: Double
    var timezone_offset: Int
    var current: [String : Any]?
    var hourly: [[String : Any]]?
    var daily: [[String : Any]]?
}

struct CurrentWeather: Identifiable, Codable {
    var id: Int
    
    var dt: Int
    var sunrise:  Int
    var sunset: Int
    var temp: Double
    var feels_like: Double
    var humidity: Int
    var uvi: Double
    var clouds: Int
    var visibility: Int
    var wind_speed: Double
    var weather: Weather
    
    init(cityId: Int) {
        self.id = cityId
        self.dt = 0
        self.sunrise = 0
        self.sunset = 0
        self.temp = 0
        self.feels_like = 0
        self.humidity = 0
        self.uvi = 0
        self.clouds = 0
        self.visibility = 0
        self.wind_speed = 0
        self.weather = Weather( id: 0,
                                main: "",
                                description: "",
                                icon: "")
    }
    
}

struct DailyWeather: Codable {
    var dt: Int
    var sunrise: Int
    var sunset: Int
    var temp: Temperature
    var weather: Weather
    var uvi: Double
}
