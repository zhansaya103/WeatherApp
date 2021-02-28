//
//  WeatherListModel.swift
//  WeatherApp
//
//  Created by Zhansaya Ayazbayeva on 2021-02-24.
//

import Foundation

class WeatherListModel: ObservableObject {
    @Published var weatherInfoList = [WeatherInfo]()
    
    func loadFromCache(cities: [City]) {
        print("EXECUTED: loadFromCache(cities: [City])")
        var weatherInfoListCopy = [WeatherInfo]()
        for city in cities {
            if let weatherInfo = PersistencyManager.shared.getCityWeatherInfo(filename: FileNamePrefixes.weatherInfo + "\(city.ident)") {
                weatherInfoListCopy.append(weatherInfo)
            } else {
                
                let task = WeatherServiceClient().load(city: city, success: { weatherInfo in
                    
                    self.weatherInfoList.append(weatherInfo)
                    
                    print("Success: weatherInfoListCopy count: \(weatherInfoListCopy.count)")
                    print("Success: weatherInfoList count: \(self.weatherInfoList.count)")
                })
                task.resume()
            }
        }
        
        weatherInfoList = weatherInfoListCopy
        print("AGAIN: weatherInfoList count: \(weatherInfoList.count)")
        
    }
    
    
    func load(cities: [City], success: @escaping (Bool) -> ()) {
        print("EXECUTED: load(cities: [City], success: @escaping (Bool) -> ())")
        var weatherInfoListCopy = [WeatherInfo]()
        let group = DispatchGroup()
        for city in cities {
            
            group.enter()
            let task = WeatherServiceClient().load(city: city,
                                                   success: { weatherInfo in
                                                    
                                                    weatherInfoListCopy.append(weatherInfo)
                                                    group.leave()
                                                   })
            task.resume()
        }
        
        group.notify(queue: .main) {
            
            self.weatherInfoList = weatherInfoListCopy.sorted(by: { (city1, city2) -> Bool in
                city1.cityName > city2.cityName
            })
            print("weatherInfoList.count after loading: \(self.weatherInfoList.count)")
            success(true)
        }
    }
    
    @objc
    func load(timer: Timer) {
        print("EXECUTED: load(timer: Timer)")
        if let userInfo = timer.userInfo as? [String: Any]{
            let cities = userInfo["cities"] as! [City]
            var weatherInfoListCopy = [WeatherInfo]()
            let group = DispatchGroup()
            for city in cities {
                
                group.enter()
                let task = WeatherServiceClient().load(city: city,
                                                       success: { weatherInfo in
                                                        weatherInfoListCopy.append(weatherInfo)
                                                        group.leave()
                                                       })
                task.resume()
            }
            
            group.notify(queue: .main) {
                
                self.weatherInfoList = weatherInfoListCopy.sorted(by: { (city1, city2) -> Bool in
                    city1.cityName > city2.cityName
                })
            }
        }
        
    }
    
}
