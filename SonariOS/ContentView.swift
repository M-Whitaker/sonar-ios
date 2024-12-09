//
//  ContentView.swift
//  SonariOS
//
//  Created by Matt Whitaker on 17/08/2024.
//

import SwiftUI

struct ContentView: View {
    @Preference(\.profiles) var profiles

    var body: some View {
        if profiles.isEmpty {
            NavigationStack {
                AddProfileView()
            }
        } else {
            TabView {
                ProjectsView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Projects")
                    }
                IssuesView()
                    .tabItem {
                        Image(systemName: "exclamationmark.triangle")
                        Text("Issues")
                    }
                Text("Explore")
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Explore")
                    }
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }
            }
        }
    }
}
