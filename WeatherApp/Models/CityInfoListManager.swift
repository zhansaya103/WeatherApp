//
//  CityListManager.swift
//  WeatherApp
//
//  Created by Zhansaya Ayazbayeva on 2021-02-23.
//

import Foundation

struct CityInfoListManager {
    
    static func loadJson(filename: String) -> [CityInfo] {
        let url = Bundle.main.url(forResource: filename, withExtension: "json")!
                let data = try! Data(contentsOf: url)
                let decoder = JSONDecoder()
        do {
            return try decoder.decode([CityInfo].self, from: data)
        } catch {
            fatalError("Couldn't parse the file \n\(error)")
        }
    }
}
