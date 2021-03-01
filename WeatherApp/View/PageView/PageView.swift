//
//  PageView.swift
//  WeatherApp
//
//  Created by Zhansaya Ayazbayeva on 2021-02-23.
//

import SwiftUI

struct PageView<Page: View>: View {
    var pages: [Page]
    @Binding var currentPage: Int
    @Binding var isList:Bool
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            PageViewController(pages: pages, currentPage: $currentPage)
            TabView(isList: $isList, numberOfPages: pages.count, currentPage: $currentPage, addingCity: .constant(false))
        }
        .ignoresSafeArea()
        .transition(AnyTransition.scale)
    }
}

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


struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView<Text>(pages: [Text("Page 1"), Text("Page 2")], currentPage: .constant(0), isList: .constant(false))
    }
}
