//
//  WeatherListView.swift
//  WeatherApp
//
//  Created by Zhansaya Ayazbayeva on 2021-02-23.
//

import SwiftUI
import CoreLocation

struct WeatherListView: View {
    @Binding var isList: Bool
    @Binding var weatherInfos: [WeatherInfo]
    var cities: FetchedResults<City>
    @State private var addingCity: Bool = false
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
                            HStack(alignment: .center, spacing: geometry.size.width / 3) {
                                VStack(alignment: .leading) {
                                    Text(Formatter.setHmm(date: Date(), seconds: weatherInfo.timezone_offset)).font(Formatter.fontLight20)
                                    Text("\(weatherInfo.cityName)").font(Formatter.fontLight35)
                                }
                                .frame(width: .none, height: geometry.size.height / 10, alignment: .leading)
                                
                                Text(Formatter.setTemp(weatherInfo.current.temp)).font(Formatter.fontLight45)
                                    .frame(width: .none, height: geometry.size.height / 10, alignment: .trailing)
                            }
                        }
                        .font(Formatter.fontLight20)
                        
                    }
                    .onDelete(perform: withAnimation {deleteCity(at:) } )
                    .listRowBackground(LinearGradient(gradient: Gradient(colors: [Color("mildGray"),  Color("darkSkyBlue")]), startPoint: .leading, endPoint: .topTrailing))
                    .foregroundColor(.white).opacity(0.8)
                    .edgesIgnoringSafeArea(.top)
                }
                .layoutPriority(1)
                .sheet(isPresented: $addingCity) {
                    withAnimation {
                        AddCityView()
                            .environment(\.managedObjectContext, context)
                    }
                }
                .onAppear {
                    print("WeatherInfos count before adding: \(weatherInfos.count)")
                }
                .onDisappear {
                    print("WeatherInfos count after adding: \(weatherInfos.count)")
                }
                .border(Color.gray)
                
                HStack(alignment: .top) {
                    Button(action: {
                        withAnimation {
                            addingCity.toggle()
                        }
                    }) {
                        Image(systemName: "plus.circle")
                    }
                    .foregroundColor(Color(.gray))
                    .font(Formatter.fontLight30)
                    .padding()
                }.offset(x: geometry.size.width * 0.40, y: -350)
                
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
