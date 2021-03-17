//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Zhansaya Ayazbayeva on 2021-03-16.
//

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {
    
    var persistencyManager: PersistencyManager!
    var weatherInfo: WeatherInfo!

    override func setUp() {
        super.setUp()
        persistencyManager = PersistencyManager.shared
        
        weatherInfo = WeatherInfo (
            id: 2761369,
            cityName: "Vienna",
            country: "AT",
            coord: CityCoordinates(lat: 48.208488, lon: 16.37208),
            timezone_offset: 0,
            current: CurrentWeather(cityId: 2761369),
            hourly: [CurrentWeather(cityId: 2761369)],
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
        
    }
    
    override func tearDown() {
        persistencyManager = nil
        weatherInfo = nil
        super.tearDown()
    }
    
    
    func test_PersistencyManager_getCityWeatherInfo() {
        let filename = FileNamePrefixes.weatherInfo + "test_Vienna"
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        try? FileManager.default.removeItem(at: url)
        
        let wrong_filename = FileNamePrefixes.weatherInfo + "test_Vienna_notExist"
        let wrong_url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(wrong_filename)
        try? FileManager.default.removeItem(at: wrong_url)
        
        do {
            try persistencyManager.saveCityWeatherInfo(data: weatherInfo, filename: filename)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        let actualResult = persistencyManager.getCityWeatherInfo(filename: filename)
        XCTAssertNotNil(actualResult)
        XCTAssertEqual(actualResult?.cityName, "Vienna")
        XCTAssertEqual(actualResult?.id, 2761369)
        XCTAssertNil(persistencyManager.getCityWeatherInfo(filename: wrong_filename))
    }
    
    func test_PersistencyManager_saveCityWeatherInfo() {
        
        let filename = FileNamePrefixes.weatherInfo + "test_Vienna"
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(filename)
        try? FileManager.default.removeItem(at: url)
        
        do {
            try persistencyManager.saveCityWeatherInfo(data: weatherInfo, filename: filename)
        } catch {
            XCTFail(error.localizedDescription)
        }
        
        let data = try? Data(contentsOf: url)
        XCTAssertNotNil(data)
        XCTAssertNoThrow(try persistencyManager.saveCityWeatherInfo(data: weatherInfo, filename: filename))
    }
    
    

}
