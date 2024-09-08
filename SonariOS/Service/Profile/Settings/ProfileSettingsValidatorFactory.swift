//
//  ProfileSettingsValidatorFactory.swift
//  SonariOS
//
//  Created by Matt Whitaker on 01/09/2024.
//

final class ProfileSettingsValidatorFactory {
    private final let sonarCloudValidators: [SonarUserDefaultsValidator] = [
        NameValidator(),
        ApiKeyValidator(),
    ]

    private final let sonarQubeValidators: [SonarUserDefaultsValidator] = [
        NameValidator(),
        ApiKeyValidator(),
        BaseUrlValidator(),
    ]

    func getValidatorsFor(profileType: UserDefaultsType) -> [SonarUserDefaultsValidator] {
        switch profileType {
        case .sonarCloud:
            sonarCloudValidators
        case .sonarQube:
            sonarQubeValidators
        }
    }
}
