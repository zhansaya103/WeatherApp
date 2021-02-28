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
    
   
    init() {
        print("ContentView init")
        let predicate = NSPredicate(format: "isFeatured = %@", argumentArray: [true])
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
            print("Value 'isFeatured' has changed")
            print("EXECUTED: weatherListModel.loadFromCache")
            weatherListModel.loadFromCache(cities: cities.map { city in city as City })
            print("weatherInfos.count after city.isFeatured had changed: \(weatherInfos.count)")
        })
        .onChange(of: weatherListModel.weatherInfoList.count, perform: { value in
            weatherInfos = weatherListModel.weatherInfoList
        })
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
