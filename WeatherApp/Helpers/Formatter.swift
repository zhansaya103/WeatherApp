//
//  TimeFormatter.swift
//  WeatherApp
//
//  Created by Zhansaya Ayazbayeva on 2021-02-25.
//

import Foundation
import SwiftUI

struct Formatter {
    
    // MARK: set Font
    
    static var fontLight45: Font {
        Font.system(size: 45, weight: .light, design: .default)
    }
    static var fontLight40: Font {
        Font.system(size: 40, weight: .light, design: .default)
    }
    static var fontLight35: Font {
        Font.system(size: 35, weight: .light, design: .default)
    }
    static var fontLight30: Font {
        Font.system(size: 30, weight: .light, design: .default)
    }
    static var fontLight25: Font {
        Font.system(size: 25, weight: .light, design: .default)
    }
    static var fontLight20: Font {
        Font.system(size: 20, weight: .light, design: .default)
    }
    static var fontLight15: Font {
        Font.system(size: 15, weight: .light, design: .default)
    }
    
    
    
    // MARK: set ImageName
    
    static func setImageName(_ weatherStatus: String) -> String {
        var imageName: String
            switch weatherStatus {
            case "sun.max.fill":
                imageName = "sun.max.fill"
            case "Thunderstorm":
                imageName = "cloud.bolt.rain.fill"
            case "Drizzle":
                imageName = "cloud.drizzle.fill"
            case "Shower Rain":
                imageName = "cloud.sun.rain.fill"
            case "Rain":
                imageName = "cloud.rain.fill"
            case "Snow":
                imageName = "cloud.snow.fill"
            case "Overcast Clouds":
                imageName = "cloud.fill"
            case "Clouds", "Few Clouds", "Scattered Clouds", "Broken Clouds":
                imageName = "cloud.sun.fill"
            case "Mist":
                imageName = "cloud.fog.fill"
            case "Sunset":
                imageName = "sunset.fill"
            case "Sunrise":
                imageName = "sunrise.fill"
            
        default:
            imageName = "sun.max.fill"
            }
        return imageName
    }
    
    // MARK: set Temp
    
    static func setTemp(_ temp: Double) -> String {
        return String(format: "%.0f°", temp)
    }
    
    // MARK: set UV Index
    static func setIndex(_ temp: Double) -> String {
        return String(format: "%.0f", temp)
    }
    
    static func getUVIndexRange(_ index: Int) -> String {
        var description: String
            switch index {
            case 0, 1, 2:
                description = "LOW"
            case 3, 4, 5:
                description = "MODERATE"
            case 6, 7:
                description = "High"
            case 8, 9:
                description = "Very High"
           
            
        default:
            description = "Extreme"
            }
        return description
    }
    
    // MARK: set Time
    static func setHmm(seconds: Int) -> String {
        let timezone = TimeZone(secondsFromGMT: seconds)
        let currentDate = Date()
        let format = DateFormatter()
        format.timeZone = timezone
        format.dateFormat = "h:mm a"
        let dateString = format.string(from: currentDate)
        return dateString
    }
    
    static func setHmm(date: Date) -> String {
        let currentDate = date
        let format = DateFormatter()
        format.dateFormat = "h:mm a"
        let dateString = format.string(from: currentDate)
        return dateString
    }
    
    static func setHmm(date: Date, seconds: Int) -> String {
        let format = DateFormatter()
        let timezone = TimeZone(secondsFromGMT: seconds)
        format.timeZone = timezone
        format.dateFormat = "h:mm a"
        let dateString = format.string(from: date)
        return dateString
    }
    
    static func setWeekday (dt: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let format = DateFormatter()
        format.dateFormat = "E"
        let dateString = format.string(from: date)
        return setWeekdayName(weekShortName: dateString)
    }
    
    static func setH (dt: Int, seconds: Int) -> String {
        let timezone = TimeZone(secondsFromGMT: seconds)
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let format = DateFormatter()
        format.timeZone = timezone
        format.dateFormat = "h a"
        let dateString = format.string(from: date)
        return dateString
    }
    
    static func setHmm (dt: Int, seconds: Int) -> String {
        let timezone = TimeZone(secondsFromGMT: seconds)
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let format = DateFormatter()
        format.timeZone = timezone
        format.dateFormat = "h:mm a"
        let dateString = format.string(from: date)
        return dateString
    }
}

fileprivate func setWeekdayName(weekShortName: String) -> String {
    var weekday: String
        switch weekShortName {
        case "Mon":
            weekday = "Monday"
        case "Tue":
            weekday = "Tuesday"
        case "Wed":
            weekday = "Wednesday"
        case "Thu":
            weekday = "Thursday"
        case "Fri":
            weekday = "Friday"
        case "Sat":
            weekday = "Saturday"
        case "Sun":
            weekday = "Sunday"
        
    default:
        weekday = ""
        }
    return weekday
}

func getUVIndexRange(index: Int) -> String {
    var description: String
        switch index {
        case 0, 1, 2:
            description = "Low"
        case 3, 4, 5:
            description = "Moderate"
        case 6, 7:
            description = "High"
        case 8, 9:
            description = "Very High"
       
        
    default:
        description = "Extreme"
        }
    return description
}

