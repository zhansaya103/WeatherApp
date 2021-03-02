//
//  ContentView.swift
//  WeatherApp
//
//  Created by Zhansaya Ayazbayeva on 2021-02-23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest var cities: FetchedResults<City>
    @SceneStorage("ContentView.isList") private var isList: Bool = true
    @ObservedObject var weatherListModel = WeatherListModel()
    @State var weatherInfos = [WeatherInfo]()
    @State var currentCityId = 0
    var userLocation: CLLocationCoordinate2D?
   
    init(userLocation: CLLocationCoordinate2D?) {
        print("ContentView init")
        self.userLocation = userLocation
        let predicate = NSPredicate(format: "isFeatured = %@ OR (longitude = %@ AND latitude = %@)", argumentArray: [true, Double(round(self.userLocation?.longitude ?? 0)), Double(round(self.userLocation?.latitude ?? 0))])
        print("User's location: lat: \(String(describing: Double(round(self.userLocation?.latitude ?? 0)))) lon: \(String(describing: Double(round(self.userLocation?.longitude ?? 0))))")
        let request = City.fetchRequest(predicate: predicate)
        _cities = FetchRequest(fetchRequest: request)
        
    }

    var body: some View {
        
        Group {
            if !isList && weatherInfos.count > 0 {
                WeatherPageView(isList: $isList, weatherInfos: $weatherInfos, currentCityId: $currentCityId)
            } else {
                WeatherListView(isList: $isList, weatherInfos: $weatherInfos, cities: cities, currentCityId: $currentCityId)
            }
        }
        .onAppear {
            print("ON APPEAR: ContentView")
            
            weatherListModel.load(cities: cities.map { city in city as City }) { success in
                print(success)
            }
            weatherListModel.loadFromCache(cities: cities.map { city in city as City })
            weatherInfos = weatherListModel.weatherInfoList
            if let weatherInfo = weatherInfos.first {
                currentCityId = weatherInfo.id
            }
            
            _ = Timer.scheduledTimer(timeInterval: 900, target: weatherListModel, selector: #selector(WeatherListModel.load(timer:)), userInfo: ["cities": cities.map { city in city as City }], repeats: true)
            
        }
        .onChange(of: cities.filter({city in city.isFeatured}), perform: { value in
            print("HAS CHANGED:'isFeatured'")
            print("EXECUTED: weatherListModel.loadFromCache")
            weatherListModel.loadFromCache(cities: cities.map { city in city as City })
            print("weatherInfos.count after city.isFeatured had changed: \(weatherInfos.count)")
        })
        .onChange(of: weatherListModel.weatherInfoList.count, perform: { value in
            print("HAS CHANGED: weatherListModel.weatherInfoList.count")
            weatherInfos = weatherListModel.weatherInfoList
        })
        .onChange(of: weatherListModel.weatherInfoList.last?.current.dt, perform: { value in
            guard let dt = value else { return }
            let current = Date().timeIntervalSince1970
            if abs(current - Double(dt)) > 180 {
                print("HAS CHANGED: weatherListModel.weatherInfoList.first?.current.dt")
                weatherListModel.loadFromCache(cities: cities.map { city in city as City })
            }
        })
        .onChange(of: userLocation?.longitude, perform: { value in
            print("HAS CHANGED: userLocation?.longitude - \(String(describing: value))")
            if let userLongitude = value  {
                let usersCity = cities.first(where: { city in city.longitude == Double(round(userLongitude))})
                print("User's City: \(usersCity?.cityName ?? "nil")")
                usersCity?.addToUsersList(context: context)
            }
        })
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(userLocation: nil).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
