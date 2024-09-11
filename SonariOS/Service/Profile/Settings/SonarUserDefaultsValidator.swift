//
//  SonarUserDefaultsValidator.swift
//  SonariOS
//
//  Created by Matt Whitaker on 01/09/2024.
//

protocol SonarUserDefaultsValidator {
    func validate(userDefaults: some SonarUserDefaults) -> Bool
}
