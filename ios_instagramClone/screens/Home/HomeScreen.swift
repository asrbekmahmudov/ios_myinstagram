//
//  HomeScreen.swift
//  ios_instagramClone
//
//  Created by Mahmudov Asrbek Ulug'bek o'g'li on 27/08/21.
//

import SwiftUI

struct HomeScreen: View {
    @State private var tabSelection = 0
    var body: some View {
        TabView(selection: $tabSelection) {
            
            FeedScreen(tabSelection: $tabSelection)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "house")
                }.tag(0)
            
            SearchScreen()
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "magnifyingglass")
                }.tag(1)
            
            UploadScreen(tabSelection: $tabSelection)
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "camera")
                }.tag(2)
            
            LikesScreen()
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "heart")
                }.tag(3)
            
            ProfileScreen()
                .font(.system(size: 30, weight: .bold, design: .rounded))
                .tabItem {
                    Image(systemName: "person")
                }.tag(4)
            
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

