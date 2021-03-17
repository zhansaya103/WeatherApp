//
//  WeatherAppAsyncTests.swift
//  WeatherAppTests
//
//  Created by Zhansaya Ayazbayeva on 2021-03-16.
//

import XCTest
@testable import WeatherApp
import CoreData


class WeatherAppAsyncTests: XCTestCase {

    var surl: URLSession!
    var persistanceContainer: NSPersistentContainer!
    var weatherListModel: WeatherListModel!
    
    override func setUp() {
        super.setUp()
        surl = URLSession(configuration: .default)
        persistanceContainer = TestPersistance.shared.container
        weatherListModel = WeatherListModel()
    }
    
    override func tearDown() {
        surl = nil
        persistanceContainer = nil
        weatherListModel = nil
        super.tearDown()
    }
    
    
    func test_ValidCallToOpenweathermapGetsHTTPStatusCode200() {
      
      let url =
        URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=24.14&lon=45.45&units=metric&exclude=minutely&appid=89c207880b6e57574dbddd2be200eaf7")
      
      let promise = expectation(description: "Status code: 200")

      let dataTask = surl.dataTask(with: url!) { data, response, error in
        
        if let error = error {
          XCTFail("Error: \(error.localizedDescription)")
          return
        } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
          if statusCode == 200 {
            
            promise.fulfill()
          } else {
            XCTFail("Status code: \(statusCode)")
          }
        }
      }
      dataTask.resume()
      
      wait(for: [promise], timeout: 5)
    }
    
    func test_WeatherByCoordServiceClient_load() {
        
        let cityInfo = CityInfo(id: 2761369, name: "Vienna", state: "", country: "AT", coord: CityCoordinates(lat: 48.208488, lon: 16.37208))
        let context = persistanceContainer.viewContext
            
        let city = WeatherApp.City(context: context)
        city.ident = Int32(cityInfo.id)
        city.name = cityInfo.name
        city.country = cityInfo.country
        city.longitude = Double(round(cityInfo.coord.lon))
        city.latitude = Double(round(cityInfo.coord.lat))
        city.isFeatured = false
        
        do {
            try context.save()
            
        } catch {
            XCTFail("Could not save city")
        }
        let promiseWeatherInfoHourlyCount = expectation(description: "TRUE: WeatherInfo.hourly.count > 1")
        let promiseCityName = expectation(description: "TRUE: WeatherInfo.cityName == Vienna")
        
        let task = WeatherServiceClient().load(city: city) { weatherInfo  in
            if  weatherInfo.cityName == "Vienna" {
                promiseCityName.fulfill()
            } else {
                XCTFail("WeatherInfo.cityName: \(weatherInfo.cityName)")
            }
            if weatherInfo.hourly.count > 1 {
                promiseWeatherInfoHourlyCount.fulfill()
            } else {
                XCTFail("WeatherInfo.hourly.count = \(weatherInfo.hourly.count)")
            }
        }
        task.resume()
        wait(for: [promiseCityName, promiseWeatherInfoHourlyCount], timeout: 5)
        
    }
    
    func test_WeatherListModel_load() {
        let cityInfo = CityInfo(id: 2761369, name: "Vienna", state: "", country: "AT", coord: CityCoordinates(lat: 48.208488, lon: 16.37208))
        let context = persistanceContainer.viewContext
            
        let city = WeatherApp.City(context: context)
        city.ident = Int32(cityInfo.id)
        city.name = cityInfo.name
        city.country = cityInfo.country
        city.longitude = Double(round(cityInfo.coord.lon))
        city.latitude = Double(round(cityInfo.coord.lat))
        city.isFeatured = false
        
        do {
            try context.save()
            
        } catch {
            XCTFail("Could not save city")
        }
        let cities: [WeatherApp.City] = [city]
        
        
        let promise_weatherInfoList_count = expectation(description: "weatherInfoList.count > 0")
        let promise_weatherInfoList_first_cityName = expectation(description: "weatherInfoList.cityName == Vienna")
        
        weatherListModel.load(cities: cities) { cityNames in
            if cityNames.count > 0 {
                promise_weatherInfoList_count.fulfill()
            }
            if cityNames[0] == "Vienna" {
                promise_weatherInfoList_first_cityName.fulfill()
            }
        }
        
        wait(for: [promise_weatherInfoList_count, promise_weatherInfoList_first_cityName], timeout: 3)
    }

    func test_WeatherListModel_loadFromCache() {
        let cityInfo = CityInfo(id: 2761369, name: "Vienna", state: "", country: "AT", coord: CityCoordinates(lat: 48.208488, lon: 16.37208))
        let context = persistanceContainer.viewContext
            
        let city = WeatherApp.City(context: context)
        city.ident = Int32(cityInfo.id)
        city.name = cityInfo.name
        city.country = cityInfo.country
        city.longitude = Double(round(cityInfo.coord.lon))
        city.latitude = Double(round(cityInfo.coord.lat))
        city.isFeatured = false
        
        do {
            try context.save()
            
        } catch {
            XCTFail("Could not save city")
        }
        let cities: [WeatherApp.City] = [city]
        
        let promise_successDic_isNotEmpty = expectation(description: "successDic is not empty")
        let promise_successDic_contains_Vienna = expectation(description: "successDic contains Vienna")
        
        weatherListModel.loadFromCache(cities: cities) { successDic in
            if !successDic.isEmpty {
                promise_successDic_isNotEmpty.fulfill()
            }
            if (successDic["Vienna"] != nil) {
                promise_successDic_contains_Vienna.fulfill()
            }
        }
        
        wait(for: [promise_successDic_isNotEmpty, promise_successDic_contains_Vienna], timeout: 3)
    }
}
