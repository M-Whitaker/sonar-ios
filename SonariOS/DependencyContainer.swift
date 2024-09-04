//
//  DependencyContainer.swift
//  SonariOS
//
//  Created by Matt Whitaker on 17/08/2024.
//

import Factory

extension Container {
    var profileSettingsValidatorFactory: Factory<ProfileSettingsValidatorFactory> {
        Factory(self) { ProfileSettingsValidatorFactory() }
            .singleton
    }

    var sonarClientFactory: Factory<SonarClientFactory> {
        Factory(self) { SonarClientFactory() }
            .singleton
    }
}
