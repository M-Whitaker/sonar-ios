//
//  SonarQubeSettingsView.swift
//  SonariOS
//
//  Created by Matt Whitaker on 01/09/2024.
//

import SwiftUI

struct SonarQubeSettingsView: View {
    @Preference(\.profiles) var profiles
    @Preference(\.currentProfileIdx) var currentProfileIdx

    var body: some View {
        Text("View")
    }
}

// #Preview {
//  SonarQubeSettingsView()
// }
