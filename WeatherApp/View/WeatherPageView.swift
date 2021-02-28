//
//  WeatherPageView.swift
//  WeatherApp
//
//  Created by Zhansaya Ayazbayeva on 2021-02-23.
//

import SwiftUI

struct WeatherPageView: View {
    @Binding var isList: Bool
    @Binding var weatherInfos: [WeatherInfo]
    @Binding var currentCityId: Int
    @State private var currentPage = 0
    var body: some View {
        let pages = getPages()
        PageView(pages: pages, currentPage: $currentPage, isList: $isList)
            .onAppear {
                getCurrentPage()
            }
    }
    
    func getCurrentPage(){
        if weatherInfos.count > 0 {
            let index = weatherInfos.firstIndex(where: {w in w.id == currentCityId })!
            currentPage = index
        }
    }
    
    func getPages() -> [WeatherView] {
        var weatherViewList = [WeatherView]()
        for weatherInfo in weatherInfos {
            weatherViewList.append(WeatherView(weatherInfo: weatherInfo))
        }
        return weatherViewList
    }
}




/*
 struct WeatherPageView_Previews: PreviewProvider {
 static var previews: some View {
 var cities: FetchedResults<City>
 WeatherPageView(isList: .constant(false), cityList: cities)
 }
 }
 */
