//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Zhansaya Ayazbayeva on 2021-02-24.
//

import SwiftUI

struct WeatherView: View {
    var weatherInfo: WeatherInfo
    var body: some View {
        GeometryReader { geometry in
            List {
                VStack {
                    VStack(spacing: 5) {
                        Group {
                            Text(weatherInfo.cityName).font(Formatter.fontLight40)
                            Text(Formatter.setHmm(date: Date(), seconds: weatherInfo.timezone_offset)).font(Formatter.fontLight25)
                        }
                        Image(systemName: Formatter.setImageName(weatherInfo.current.weather.description.capitalized) )
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width * 0.3, height: geometry.size.width * 0.3 )
                            .brightness(0.1)
                        Text(Formatter.setTemp(weatherInfo.current.temp)).font(Formatter.fontLight45)
                        Text(weatherInfo.current.weather.description.capitalized).font(Formatter.fontLight25)
                    }
                    .padding()
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Label("UV INDEX", systemImage: " ")
                            .labelStyle(TitleOnlyLabelStyle())
                            .font(Formatter.fontLight20)
                        HStack(alignment: .center) {
                            Label("\(Formatter.setIndex(weatherInfo.current.uvi))", systemImage: " ")
                                .labelStyle(TitleOnlyLabelStyle())
                                .font(Formatter.fontLight40)
                            Text("\(Formatter.getUVIndexRange(Int(weatherInfo.current.uvi)))").font(Formatter.fontLight15)
                        }
                    }
                    .padding(15)
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height / 15, alignment: .trailing)
                    Divider()
                    WeatherHourlyView(geometry: geometry, weatherInfo: weatherInfo)
                    Divider()
                    WeatherDailyView(geometry: geometry, weatherInfo: weatherInfo)
                }
                .listRowBackground(Color(.clear))
                .listRowInsets(.none)
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color("darkSkyBlue"), Color("mildGray")]), startPoint: .topLeading, endPoint: .bottomLeading))
            .foregroundColor(.white)
            .ignoresSafeArea()
            .onAppear {
                UITableView.appearance().backgroundColor = .clear
                UITableViewCell.appearance().backgroundColor = .clear
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weatherInfo: WeatherInfo(id: 0, cityName: "Vancouver", country: "CA", coord: CityCoordinates(lat: 0, lon: 0), timezone_offset: 1, current: CurrentWeather(cityId: 2), hourly: [CurrentWeather(cityId: 2)], daily: [DailyWeather(dt: 1, sunrise: 0, sunset: 0, temp: Temperature(day: 1, eve: 0, max: 0, min: 0, morn: 0, night: 1), weather: Weather(id: 0, main: "", description: "snow", icon: ""), uvi: 4), DailyWeather(dt: 1, sunrise: 0, sunset: 0, temp: Temperature(day: 1, eve: 0, max: 0, min: 0, morn: 0, night: 1), weather: Weather(id: 0, main: "", description: "snow", icon: ""), uvi: 0), DailyWeather(dt: 1, sunrise: 0, sunset: 0, temp: Temperature(day: 1, eve: 0, max: 0, min: 0, morn: 0, night: 1), weather: Weather(id: 0, main: "", description: "snow", icon: ""), uvi: 0), DailyWeather(dt: 1, sunrise: 0, sunset: 0, temp: Temperature(day: 1, eve: 0, max: 0, min: 0, morn: 0, night: 1), weather: Weather(id: 0, main: "", description: "snow", icon: ""), uvi: 0), DailyWeather(dt: 1, sunrise: 0, sunset: 0, temp: Temperature(day: 1, eve: 0, max: 0, min: 0, morn: 0, night: 1), weather: Weather(id: 0, main: "", description: "snow", icon: ""), uvi: 0)]))
    }
}

struct WeatherHourlyView: View {
    var geometry: GeometryProxy
    var weatherInfo: WeatherInfo
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: geometry.size.width * 0.15) {
                Text(Formatter.setWeekday(dt: weatherInfo.current.dt))
            }
            .fixedSize(horizontal: false, vertical: false)
            .aspectRatio(contentMode: .fill)
            .font(Formatter.fontLight25)
            HStack {
                VStack(spacing: 10) {
                    Text("NOW").font(Formatter.fontLight20)
                    Image(systemName: Formatter.setImageName(weatherInfo.current.weather.description.capitalized))
                        .renderingMode(.original)
                        .brightness(0.1)
                    Text(Formatter.setTemp(weatherInfo.current.temp))
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(1..<weatherInfo.hourly.count, id: \.self) { index in
                            VStack(spacing: 10) {
                                Text(Formatter.setH(dt: weatherInfo.hourly[index].dt, seconds: weatherInfo.timezone_offset)).font(Formatter.fontLight20)
                                Image(systemName: Formatter.setImageName(weatherInfo.hourly[index].weather.description.capitalized))
                                    .renderingMode(.original)
                                    .brightness(0.1)
                                Text(Formatter.setTemp(weatherInfo.hourly[index].temp))
                            }
                        }
                    }
                }
            }
            .font(Formatter.fontLight25)
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        
    }
}

struct WeatherDailyView: View {
    var geometry: GeometryProxy
    var weatherInfo: WeatherInfo
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(1..<weatherInfo.daily.count) { index in
                        HStack(alignment: .top, spacing: 8) {
                            VStack(alignment: .leading) {
                                Text(Formatter.setWeekday(dt: weatherInfo.daily[index].dt))
                                    .frame(width: geometry.size.width / 2.5 , alignment: .leading)
                            }
                            VStack (alignment: .leading) {
                                Image(systemName: Formatter.setImageName(weatherInfo.daily[index].weather.main) )
                                    .renderingMode(.original)
                                    .brightness(0.1)
                                    .frame(width: geometry.size.width / 8, alignment: .center)
                            }
                            VStack(alignment: .trailing) {
                                HStack(spacing: 5) {
                                    Text(Formatter.setTemp(weatherInfo.daily[index].temp.day))
                                        .frame(width: geometry.size.width / 8, alignment: .leading)
                                    Text(Formatter.setTemp(weatherInfo.daily[index].temp.night)).foregroundColor(Color(.black)).opacity(0.6)
                                        .frame(width: geometry.size.width / 8, alignment: .trailing)
                                }
                                .aspectRatio(contentMode: .fit)
                            }
                        }
                    }
                }
            }
        }
        .fixedSize(horizontal: true, vertical: true)
        .aspectRatio(contentMode: .fill)
        .padding()
        .font(Formatter.fontLight25)
    }
}
