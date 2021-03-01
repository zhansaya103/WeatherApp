//
//  WeatherListView.swift
//  WeatherApp
//
//  Created by Zhansaya Ayazbayeva on 2021-02-23.
//

import SwiftUI
import CoreLocation
import UIKit

struct WeatherListView: View {
    @Binding var isList: Bool
    @Binding var weatherInfos: [WeatherInfo]
    var cities: FetchedResults<City>
    @State var addingCity: Bool = false
    @Binding var currentCityId: Int
    @Environment(\.managedObjectContext) var context
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                List {
                    ForEach(weatherInfos, id: \.id) { weatherInfo in
                        Button(action: {
                            currentCityId = weatherInfo.id
                            print("currentCityId: \(currentCityId)")
                                isList.toggle()
                        }) {
                            HStack(alignment: .center, spacing: geometry.size.width / 6) {
                                VStack(alignment: .leading) {
                                    Text(Formatter.setHmm(date: Date(), seconds: weatherInfo.timezone_offset)).font(Formatter.fontLight20)
                                    Text("\(weatherInfo.cityName)").font(Formatter.fontLight35)
                                }
                                .frame(width: geometry.size.width * 1 / 3, height: geometry.size.height / 10, alignment: .leading)
                                HStack {
                                    Image(systemName: Formatter.setImageName(weatherInfo.current.weather.description.capitalized) )
                                        .renderingMode(.original)
                                        .frame(width: geometry.size.width * 0.20, height: geometry.size.width * 0.20, alignment: .trailing)
                                        .font(Formatter.fontLight35)
                                    Text(Formatter.setTemp(weatherInfo.current.temp)).font(Formatter.fontLight45)
                                        .frame(width: geometry.size.width * 0.20, height: geometry.size.height / 10, alignment: .trailing)
                                }
                                
                            }
                            .frame(height: 70, alignment: .leading)
                        }
                        .font(Formatter.fontLight20)
                    }
                    .onDelete(perform: withAnimation {deleteCity(at:) } )
                    .listRowBackground(Color(.gray).opacity(0.3))
                    .foregroundColor(.white).opacity(0.8)
                    .edgesIgnoringSafeArea(.top)
                }
                .background(LinearGradient(gradient: Gradient(colors: [Color("darkSkyBlue"), Color("mildGray")]), startPoint: .topLeading, endPoint: .bottomLeading))
                .layoutPriority(1)
                .sheet(isPresented: $addingCity) {
                    withAnimation {
                        AddCityView()
                            .environment(\.managedObjectContext, context)
                    }
                }
                .onAppear {
                    UITableView.appearance().backgroundColor = .clear
                    UITableViewCell.appearance().backgroundColor = .clear
                    print("WeatherInfos count before adding: \(weatherInfos.count)")
                }
                .onDisappear {
                    print("WeatherInfos count after adding: \(weatherInfos.count)")
                }
                .border(Color.gray)
                TabView(isList: $isList, numberOfPages: weatherInfos.count, currentPage: $currentCityId, addingCity: $addingCity)
                    .position(x: geometry.size.width / 2, y: (80 * CGFloat(weatherInfos.count + 1)))
               
                
            }
            .ignoresSafeArea([.all])
            
        }
    }
    
    func deleteCity(at offsets: IndexSet) {
        print("Executed: deleteCity(at offsets: IndexSet)")
        offsets.forEach { index in
            let weatherInfo = self.weatherInfos[index]
            print("WeatherInfo of \(weatherInfo.cityName) is removing from UserList")
            print("UserList weatherInfos count befor: \(weatherInfos.count)")
            self.weatherInfos.remove(at: index)
            print("UserList weatherInfos count after: \(weatherInfos.count)")
            if let city = self.cities.first(where: { city in city.ident == weatherInfo.id}) {
                print("\(city.cityName) is removing from UserList")
                city.removeFromUsersList(context: self.context)
            }
        }
    }
}
















/*
 struct WeatherListView_Previews: PreviewProvider {
 static var previews: some View {
 var cities: FetchedResults<City>
 WeatherListView(cityList: cities)
 }
 }
 */
