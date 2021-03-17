//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Zhansaya Ayazbayeva on 2021-02-23.
//

import SwiftUI
import CoreLocation

@main
struct WeatherAppApp: App {
    let persistenceController = PersistenceController.shared
    @Environment(\.scenePhase) var scenePhase
    let locationFetcher = LocationFetcher()
    init() {
        print("App init")
        loadCityList()
        print("Cities loaded to Core Data")
        
        getUserLocation()
    }
    var body: some Scene {
        WindowGroup {
            ContentView(userLocation: locationFetcher.lastKnownLocation)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { newScenePhase in
            switch newScenePhase {
            case .background:
                print("App State: Background")
            case .inactive:
                print("App State: Inactive")
            case .active:
                print("App State: Active")
                getUserLocation()
            @unknown default:
                print("App State: Unknown")
            }
        }
    }
    
    func loadCityList() {
        let cityInfoList = CityInfoListManager.loadJson(filename: "city.list")
        for cityInfo in cityInfoList {
            City.update(from: cityInfo, context: persistenceController.container.viewContext)
            
        }
    }
    func getUserLocation() {
        locationFetcher.start()
        print("LOCATION: lat - \(String(describing: locationFetcher.lastKnownLocation?.latitude))")  //MOSCOW: 55.755786   TOKYO: 35.7020691
        print("LOCATION: lon - \(String(describing: locationFetcher.lastKnownLocation?.longitude))") //MOSCOW: 37.617633   TOKYO: 139.7753269
    }
  
}
