//
//  SonarClientFactory.swift
//  SonariOS
//
//  Created by Matt Whitaker on 11/09/2024.
//

class SonarClientFactory {
    var current: SonarClient {
        let type = Preferences.standard.profiles[Preferences.standard.currentProfileIdx].userDefaults.type
        switch type {
        case .sonarQube:
            return SonarQubeClient(sonarHttpClient: SonarHttpClient())
        case .sonarCloud:
            return SonarCloudClient(sonarHttpClient: SonarHttpClient())
        }
    }
}
