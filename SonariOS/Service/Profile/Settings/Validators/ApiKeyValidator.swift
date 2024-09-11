//
//  ApiKeyValidator.swift
//  SonariOS
//
//  Created by Matt Whitaker on 08/09/2024.
//

class ApiKeyValidator: SonarUserDefaultsValidator {
    typealias T = SonarUserDefaults

    func validate(userDefaults: some SonarUserDefaults) -> Bool {
        !userDefaults.apiKey.isEmpty
    }
}
