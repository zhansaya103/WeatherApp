//
//  TabView.swift
//  WeatherApp
//
//  Created by Zhansaya Ayazbayeva on 2021-03-01.
//

import SwiftUI

struct TabView: View {
    @Binding var isList:Bool
    @State private var showSafari: Bool = false
    private let url = URL(string: "https://openweathermap.org/")
    var numberOfPages: Int
    @Binding var currentPage: Int
    @Binding var addingCity: Bool
    
    var body: some View {
        Group {
            HStack(alignment: .top, spacing: 10) {
                Button(action: {
                    showSafari.toggle()
                }) {
                    Image(systemName: "globe")
                }
                .sheet(isPresented: $showSafari) {
                    SafariView(url: url!)
                }
                .padding(.leading)
                Spacer()
                if isList {
                    Group {
                    }
                } else {
                    PageControl(numberOfPages: .constant(numberOfPages) , currentPage: $currentPage)
                        .frame(width: CGFloat(numberOfPages * 18))
                        .padding(.horizontal)
                }
                Spacer()
                Button(action: {
                    isList ? addingCity.toggle() :  isList.toggle()
                }) {
                    Image(systemName: isList ? "plus.circle" : "list.bullet")
                }
                .padding(.trailing)
            }
            .foregroundColor(Color("ligthGray"))
            .font(Formatter.fontLight30)
            .brightness(0.1)
            .frame(height: 60, alignment: .center)
            .background(Color(.gray).opacity(isList ? 0 : 1))
        }
    }
}


struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView(isList: .constant(true), numberOfPages: 2, currentPage: .constant(0), addingCity: .constant(false))
            
    }
}
