//
//  NameValidator.swift
//  SonariOS
//
//  Created by Matt Whitaker on 01/09/2024.
//

class NameValidator: SonarUserDefaultsValidator {
    typealias T = SonarUserDefaults

    func validate(userDefaults: some SonarUserDefaults) -> Bool {
        !userDefaults.name.isEmpty
    }
}
