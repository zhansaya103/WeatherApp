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



struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView<Text>(pages: [Text("Page 1"), Text("Page 2")], currentPage: .constant(0), isList: .constant(false))
    }
}
