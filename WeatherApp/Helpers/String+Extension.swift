//
//  String+Extension.swift
//  WeatherApp
//
//  Created by Zhansaya Ayazbayeva on 2021-02-24.
//

extension String {
    mutating func addArgument(name: String, value: Double) {
        self += (hasSuffix("?") ? "" : "&") + name + "=" + "\(value)"
    }
    mutating func addArgument(name: String, value: String) {
        self += (hasSuffix("?") ? "" : "&") + name + "=" + value
    }
    mutating func addArgument(name: String, values: [String]) {
        var value = values.first!
        for index in 1..<values.count {
            value.append(",\(values[index])")
        }
        self += (hasSuffix("?") ? "" : "&") + name + "=" + value
    }
}
