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
            ZStack(alignment: .bottom) {
                LinearGradient(gradient: Gradient(colors: [Color("darkSkyBlue"), Color("mildGray")]), startPoint: .topLeading, endPoint: .bottomLeading)
                VStack {
                    VStack {
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
                        Text(Formatter.setTemp(weatherInfo.current.temp)).font(Formatter.fontLight40)
                    }
                    WeatherHourlyView(geometry: geometry, weatherInfo: weatherInfo)
                    Divider()
                    WeatherDailyView(geometry: geometry, weatherInfo: weatherInfo)
                }
            }
            .foregroundColor(.white)
            .ignoresSafeArea()
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weatherInfo: WeatherInfo(id: 0, cityName: "Vancouver", country: "CA", coord: CityCoordinates(lat: 0, lon: 0), timezone_offset: 1, current: CurrentWeather(cityId: 2), hourly: [CurrentWeather(cityId: 2)], daily: [DailyWeather(dt: 0, sunrise: 0, sunset: 0, temp: Temperature(day: 0, eve: 0, max: 0, min: 0, morn: 0, night: 0), weather: Weather(id: 0, main: "", description: "snow", icon: ""), uvi: 0)]))
    }
}

struct WeatherHourlyView: View {
    var geometry: GeometryProxy
    var weatherInfo: WeatherInfo
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: geometry.size.width * 0.15){
                Text(Formatter.setWeekday(dt: weatherInfo.current.dt))
                Text(weatherInfo.current.weather.description.capitalized + "   " + Formatter.setTemp(weatherInfo.current.temp))
                
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
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(0..<weatherInfo.daily.count) { index in
                        HStack(alignment: .top, spacing: 15) {
                            VStack(alignment: .leading) {
                                Text(Formatter.setWeekday(dt: weatherInfo.daily[index].dt))
                                    .frame(width: geometry.size.width * 0.5, alignment: .leading)
                            }
                            VStack (alignment: .leading) {
                                Image(systemName: Formatter.setImageName(weatherInfo.daily[index].weather.main) )
                                    .renderingMode(.original)
                                    .brightness(0.1)
                            }
                            VStack(alignment: .trailing) {
                                HStack(spacing: 10) {
                                    Text(Formatter.setTemp(weatherInfo.daily[index].temp.day))
                                        .frame(alignment: .leading)
                                    Text(Formatter.setTemp(weatherInfo.daily[index].temp.night)).foregroundColor(Color(.gray)).opacity(0.8)
                                        .frame(alignment: .trailing)
                                }
                                .frame(width: geometry.size.width * 0.3, alignment: .center)
                                .aspectRatio(contentMode: .fill)
                            }
                        }
                    }
                }
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .aspectRatio(contentMode: .fill)
        .padding()
        .font(Formatter.fontLight25)
    }
}
