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
    @State private var showSafari: Bool = false
    private let url = URL(string: "https://openweathermap.org/")
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                PageViewController(pages: pages, currentPage: $currentPage)
                HStack(alignment: .top, spacing: geometry.size.width / 12) {
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
                    PageControl(numberOfPages: .constant(pages.count) , currentPage: $currentPage)
                        .frame(width: CGFloat(pages.count * 18))
                        .padding(.horizontal)
                    Spacer()
                    Button(action: {
                        isList.toggle()
                    }) {
                        Image(systemName: "list.bullet")
                    }
                    .padding(.trailing)
                }
                .offset(x: 0, y: geometry.size.height * 0.95)
                .foregroundColor(Color("ligthGray"))
                .font(Formatter.fontLight30)
                .brightness(0.1)
                .frame(width: geometry.size.width, alignment: .center)
            }
            
        }
        .ignoresSafeArea()
        .transition(AnyTransition.scale)
        
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView<Text>(pages: [Text("Page 1"), Text("Page 2")], currentPage: .constant(0), isList: .constant(false))
    }
}
