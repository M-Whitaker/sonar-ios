//
//  SettingsViewModel.swift
//  SonariOS
//
//  Created by Matt Whitaker on 07/12/2024.
//

import Factory
import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var email: String = ""

    @Injected(\.sonarClientFactory) var sonarClientFactory

    @MainActor
    public func retrieveUserInfo() async throws {
        let user = try await sonarClientFactory.current.retrieveCurrentUser()
        name = user.name
        email = user.email ?? ""
    }
}
