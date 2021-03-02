//
//  City.swift
//  WeatherApp
//
//  Created by Zhansaya Ayazbayeva on 2021-02-23.
//

import CoreData

extension City {
    
    var cityName: String {
        if let name = name,
           let country = country {
            return "\(name), \(country)"
        }
        return "Unknown"
    }
    
    func addToUsersList(context: NSManagedObjectContext) {
        print("EXECUTED: addToUsersList(context: NSManagedObjectContext)")
        self.isFeatured = true
        try? context.save()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        print("context saved and merged")
    }
    
    func removeFromUsersList(context: NSManagedObjectContext) {
        print("EXECUTED: removeFromUsersList(context: NSManagedObjectContext)")
        self.isFeatured = false
        try? context.save()
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    }
    
    static func update(from info: CityInfo, context: NSManagedObjectContext) {
        print("EXECUTED: update(from info: CityInfo, context: NSManagedObjectContext)")
        let request = fetchRequest(predicate: NSPredicate(format: "ident > 0"))
        do {
            let cities = try context.fetch(request)
            if !(cities.contains(where: {city in city.ident == info.id})) {
                let city = City(context: context)
                city.ident = Int32(info.id)
                city.name = info.name
                city.country = info.country
                city.longitude = Double(round(info.coord.lon))
                city.latitude = Double(round(info.coord.lat))
                city.isFeatured = false
                print("\(city.cityName) is loaded to Core Data")
            }
        } catch {
            print("Could not fetch request")
        }
        do {
            try context.save()
            print("Context saved")
        } catch {
            print("Could not save context")
        }
        
        
    }
    
    static func fetchRequest(predicate: NSPredicate) -> NSFetchRequest<City> {
        let request = NSFetchRequest<City>(entityName: "City")
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.predicate = predicate
        return request
    }
}
