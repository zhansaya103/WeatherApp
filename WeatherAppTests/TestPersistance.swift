//
//  TestPersistance.swift
//  WeatherAppTests
//
//  Created by Zhansaya Ayazbayeva on 2021-03-17.
//

import CoreData
import WeatherApp

class TestPersistance {
    static let shared = TestPersistance()
    let container: NSPersistentContainer
    
    init() {
        let persistentStoreDescription = NSPersistentStoreDescription()
            persistentStoreDescription.type = NSInMemoryStoreType
        container = NSPersistentContainer(name: "WeatherApp")
        container.persistentStoreDescriptions = [persistentStoreDescription]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            print("store type: \(storeDescription.type)")
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

}
