//
//  BaseUrlValidator.swift
//  SonariOS
//
//  Created by Matt Whitaker on 01/09/2024.
//

class BaseUrlValidator: SonarUserDefaultsValidator {
    func validate(userDefaults: some SonarUserDefaults) -> Bool {
        guard let qubeUserDefaults = userDefaults as? SonarQubeUserDefaults else { fatalError("userDefaults must be of type SonarQubeUserDefaults for this validator") }
        let baseUrl = qubeUserDefaults.baseUrl
        return !baseUrl.isEmpty && !baseUrl.contains(/^https?:\/\//) && baseUrl == baseUrl.lowercased() && baseUrl == baseUrl.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
