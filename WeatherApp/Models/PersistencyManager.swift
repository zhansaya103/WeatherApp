//
//  PersistencyManager.swift
//  WeatherApp
//
//  Created by Zhansaya Ayazbayeva on 2021-02-24.
//

import Foundation
import UIKit

enum FileNamePrefixes {
    static let weatherInfo = "WeatherInfoForCity-"
}

enum SaveToCacheError: Error {
    case encodeFailed
    case writeToURLFailed
}

class PersistencyManager {
    static var shared = PersistencyManager()
    
    private init() {
        
    }
    
    private var cache: URL {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    func saveCityWeatherInfo(data: WeatherInfo, filename: String) throws {
        print("EXECUTED: saveCityWeatherInfo(data: WeatherInfo, filename: String)")
        let url = cache.appendingPathComponent(filename)
        let encoder = JSONEncoder()
        guard let encodedData = try? encoder.encode(data) else {
            throw SaveToCacheError.encodeFailed
        }
        do {
            try encodedData.write(to: url)
            print("SUCCESS: write data to file")
        } catch {
            print("FAILED: write data to file")
            throw SaveToCacheError.writeToURLFailed
        }
    }
    
    func getCityWeatherInfo(filename: String) -> WeatherInfo? {
        print("EXECUTED: getCityWeatherInfo(filename: String)")
        let savedUrl = cache.appendingPathComponent(filename)
        let data = try? Data(contentsOf: savedUrl)
        if let weatherInfo = data,
           let decodedWeatherInfo = try? JSONDecoder().decode(WeatherInfo.self, from: weatherInfo) {
            print("SUCCESS: get data from file")
            return decodedWeatherInfo
        }
        return nil
    }
}
