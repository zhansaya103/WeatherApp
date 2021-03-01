//
//  WeatherServiceClient.swift
//  WeatherApp
//
//  Created by Zhansaya Ayazbayeva on 2021-02-24.
//

import Foundation
import UIKit

enum URLUnits {
    static let metric = "metric"
    static let imperial = "imperial"
    static let standard = "standard"
}

enum URLExcludeData {
    static let current = "current"
    static let minutely = "minutely"
    static let hourly = "hourly"
    static let daily = "daily"
    static let alerts = "alerts"
}

enum APIKeys {
    static let myKey = "89c207880b6e57574dbddd2be200eaf7"
}

struct WeatherServiceClient {
    
    func load(city: City, success: @escaping (WeatherInfo) -> ()) -> URLSessionTask {
        print("EXECUTED: WeatherServiceClient func: load(city: \(city.cityName), success: @escaping (WeatherInfo) -> ())")
        let lon = city.longitude
        let lat = city.latitude
        let cityName = city.name!
        let cityId = Int(city.ident)
        let country = city.country!
        
        var url: String {
            var root = "https://api.openweathermap.org/data/2.5/onecall?"
            root.addArgument(name: "lat", value: lat)
            root.addArgument(name: "lon", value: lon)
            root.addArgument(name: "units", value: URLUnits.metric)
            root.addArgument(name: "exclude", values: [URLExcludeData.minutely, URLExcludeData.alerts])
            root.addArgument(name: "appid", value: APIKeys.myKey)
            return root
        }
        
        //let urll = "https://api.openweathermap.org/data/2.5/onecall?lat=49.24966&lon=-123.119339&units=metric&exclude=minutely&appid=89c207880b6e57574dbddd2be200eaf7"
       
        return URLSession.shared.dataTask(with: URL(string: url)!) {(data, response, error) in
            var weatherInfoCopy = WeatherInfoByCoord()
            guard let urlContent = data else {
                if error != nil {
                    print("ERROR: in URLSession task: " + error.debugDescription)
                }
                return }
            DispatchQueue.main.async {
                
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        //print(jsonResult)
                        
                        if let weatherByCoord = jsonResult as? [String: Any] {
                            
                            weatherInfoCopy.lat = weatherByCoord["lat"] as! Double
                            weatherInfoCopy.lon = weatherByCoord["lon"] as! Double
                            weatherInfoCopy.current = weatherByCoord["current"] as? [String : Any]
                            weatherInfoCopy.hourly = weatherByCoord["hourly"] as? [[String : Any]]
                            weatherInfoCopy.daily = weatherByCoord["daily"] as? [[String : Any]]
                            weatherInfoCopy.timezone_offset = weatherByCoord["timezone_offset"] as! Int
                        }
                    } catch {
                        print("JSON Processing Failed")
                    }
                var weatherInfo = WeatherInfo (
                    id: cityId,
                    cityName: cityName,
                    country: country,
                    coord: CityCoordinates(lat: 0, lon: 0),
                    timezone_offset: 0,
                    current: CurrentWeather(cityId: 0),
                    hourly: [CurrentWeather(cityId: 0)],
                    daily: [DailyWeather(
                                dt: 0,
                                sunrise: 0,
                                sunset: 0,
                                temp: Temperature(
                                    day: 0,
                                    eve: 0,
                                    max: 0,
                                    min: 0,
                                    morn: 0,
                                    night: 0),
                                weather: Weather(
                                    id: 0,
                                    main: "",
                                    description: "",
                                    icon: ""),
                                uvi: 0)])
                
                weatherInfo.coord.lat = weatherInfoCopy.lat
                weatherInfo.coord.lon = weatherInfoCopy.lon
                weatherInfo.current.dt = weatherInfoCopy.current!["dt"] as! Int
                weatherInfo.current.temp = weatherInfoCopy.current!["temp"] as! Double
                weatherInfo.current.feels_like = weatherInfoCopy.current!["feels_like"] as! Double
                weatherInfo.current.humidity = weatherInfoCopy.current!["humidity"] as! Int
                weatherInfo.timezone_offset = weatherInfoCopy.timezone_offset
                weatherInfo.current.sunset = weatherInfoCopy.current!["sunset"] as! Int
                weatherInfo.current.sunrise = weatherInfoCopy.current!["sunrise"] as! Int
                weatherInfo.current.uvi = weatherInfoCopy.current!["uvi"] as! Double
                let currWeather = weatherInfoCopy.current!["weather"] as! [[String : Any]]
                weatherInfo.current.weather.description = currWeather[0]["description"] as! String
                weatherInfo.current.weather.main = currWeather[0]["main"] as! String
                weatherInfo.current.weather.icon = currWeather[0]["icon"] as! String
                
                var hourly = [CurrentWeather]()
                let hourlyCopy = weatherInfoCopy.hourly!
                for info in hourlyCopy {
                    var elem = CurrentWeather(cityId: cityId)
                    elem.dt = info["dt"] as! Int
                    elem.temp = info["temp"] as! Double
                    elem.feels_like = info["feels_like"] as! Double
                    elem.humidity = info["humidity"] as! Int
                    elem.uvi = info["uvi"] as! Double
                    
                    let weatherCopy = info["weather"] as! [[String : Any]]
                    elem.weather.main = weatherCopy[0]["main"] as! String
                    elem.weather.description = weatherCopy[0]["description"] as! String
                    elem.weather.icon = weatherCopy[0]["icon"] as! String
                    hourly.append(elem)
                }
                
                var daily = [DailyWeather]()
                let dailyCopy = weatherInfoCopy.daily!
                for info in dailyCopy {
                    var elem = DailyWeather(dt: 0,
                                            sunrise: 0,
                                            sunset: 0,
                                            temp: Temperature(
                                                day: 0,
                                                eve: 0,
                                                max: 0,
                                                min: 0,
                                                morn: 0,
                                                night: 0),
                                            weather: Weather(
                                                id: 0,
                                                main: "",
                                                description: "",
                                                icon: ""),
                                            uvi: 0)
                    
                    elem.dt = info["dt"] as! Int
                    elem.uvi = info["uvi"] as! Double
                    let tempCopy = info["temp"] as! [String : Any]
                    elem.temp.day = tempCopy["day"] as! Double
                    elem.temp.night = tempCopy["night"] as! Double
                    
                    let weatherCopy = info["weather"] as! [[String : Any]]
                    elem.weather.main = weatherCopy[0]["main"] as! String
                    elem.weather.description = weatherCopy[0]["description"] as! String
                    elem.weather.icon = weatherCopy[0]["icon"] as! String
                    daily.append(elem)
                }
                weatherInfo.hourly = hourly
                weatherInfo.daily = daily
                PersistencyManager.shared.saveCityWeatherInfo(data: weatherInfo, filename: FileNamePrefixes.weatherInfo + "\(cityId)")
                success(weatherInfo)
            }
            
        }
    }
}
