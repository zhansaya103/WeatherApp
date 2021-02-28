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

    init() {
        print("App init")
        loadCityList()
        print("Cities loaded to Core Data")
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
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
        let locationManager = LocationManager()
        var lon = 0.0
        var lat = 0.0
        if let userLocation = locationManager.lastLocation {
            lon = userLocation.coordinate.longitude
            lat = userLocation.coordinate.latitude
            print("lon: \(lon)")
            print("lat: \(lat)")
            UserDefaults.standard.setValue(userLocation, forKey: "userLocation")
        }
        
    }
}
