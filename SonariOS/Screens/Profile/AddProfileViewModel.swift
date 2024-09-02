//
//  AddProfileViewModel.swift
//  SonariOS
//
//  Created by Matt Whitaker on 01/09/2024.
//

import Factory
import SwiftUI

class AddProfileViewModel: ObservableObject {
    @Injected(\.profileSettingsValidatorFactory) var validatorFactory
    @Preference(\.profiles) var profiles
    @Published var userDefaultsType: UserDefaultsType = .sonarCloud
    @Published var name: String = ""
    @Published var apiKey: String = ""
    @Published var baseUrl: String = ""

    @Published var valid = false

    func formSubmit() {
        // TODO: Need some validation
        var sonarUserDefaults: SonarUserDefaults? = nil
        if userDefaultsType == .sonarQube {
            sonarUserDefaults = SonarQubeUserDefaults(id: "\(Bundle.main.artifactName).\(name)", name: name, apiKey: apiKey, baseUrl: baseUrl.lowercased())
        } else if userDefaultsType == .sonarCloud {
            sonarUserDefaults = SonarCloudUserDefaults(id: "\(Bundle.main.artifactName).\(name)", name: name, apiKey: apiKey)
        }
        guard let userDefaults = sonarUserDefaults else {
            return
        }
        userDefaults.userDefaults = UserDefaults(suiteName: userDefaults.id)
        profiles.append(SonarUserDefaultsWrapper(userDefaults: userDefaults))
        print("Added new profile")
    }

    func formValidate() {
        let validators = validatorFactory.getValidators(profileType: userDefaultsType)
        for validator in validators {
            valid = validator.validate()
        }
    }
}
