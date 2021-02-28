//
//  CityInfo.swift
//  WeatherApp
//
//  Created by Zhansaya Ayazbayeva on 2021-02-23.
//

import SwiftUI
import CoreLocation

struct CityInfo: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var state: String?
    var country: String
    var coord: CityCoordinates
  }


struct CityCoordinates: Hashable, Codable {
    var lat: Double
    var lon: Double
}
