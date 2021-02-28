//
//  AddCityView.swift
//  WeatherApp
//
//  Created by Zhansaya Ayazbayeva on 2021-02-24.
//

import SwiftUI
import CoreData

struct AddCityView: View {
    @State private var searchText = ""
    @Environment(\.managedObjectContext) var context
    @FetchRequest var cities: FetchedResults<City>
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        print("init AddCity")
        let predicate = NSPredicate(format: "ident != 0")
        let request = City.fetchRequest(predicate: predicate)
        _cities = FetchRequest(fetchRequest: request)
    }
    
    var body: some View {
        let filteredCityList = cities.filter({ self.searchText.isEmpty ? true : $0.name!.lowercased().hasPrefix(self.searchText.lowercased())})
        
        Form {
            SearchBar(text: $searchText)
            ForEach(filteredCityList) { city in
                Text(city.cityName)
                    .onTapGesture {
                        print("\(city.cityName) is Tapped")
                        city.addToUsersList(context: context)
                        print("\(city.cityName) is added to UserList")
                        self.presentationMode.wrappedValue.dismiss()
                        print("AddCity dismissed")
                    }
            }
        }
    }
}

struct AddCityView_Previews: PreviewProvider {
    static var previews: some View {
        AddCityView()
    }
}
