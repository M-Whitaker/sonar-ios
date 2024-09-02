//
//  ProfileSettingsValidatorFactory.swift
//  SonariOS
//
//  Created by Matt Whitaker on 01/09/2024.
//

final class ProfileSettingsValidatorFactory {
    private final let sonarCloudValidators: [ProfileSettingsValidator] = [
        NameValidator(),
    ]

    private final let sonarQubeValidators: [ProfileSettingsValidator] = [
        BaseUrlValidator(),
    ]

    func getValidators(profileType: UserDefaultsType) -> [ProfileSettingsValidator] {
        switch profileType {
        case .sonarCloud:
            sonarCloudValidators
        case .sonarQube:
            sonarQubeValidators
        }
    }
}
