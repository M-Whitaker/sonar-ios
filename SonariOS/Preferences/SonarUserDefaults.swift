//
//  SonarUserDefaults.swift
//  SonariOS
//
//  Created by Matt Whitaker on 31/08/2024.
//

import Foundation

enum UserDefaultsType: CaseIterable, Identifiable, CustomStringConvertible, Codable {
    case sonarQube
    case sonarCloud

    var id: Self { self }
    var description: String {
        switch self {
        case .sonarQube:
            "Sonar Qube"
        case .sonarCloud:
            "Sonar Cloud"
        }
    }

    var metatype: SonarUserDefaults.Type {
        switch self {
        case .sonarQube:
            SonarQubeUserDefaults.self
        case .sonarCloud:
            SonarCloudUserDefaults.self
        }
    }
}

enum InvalidStateError: Error {
    case runtimeError(String)
}

class SonarUserDefaults: Identifiable, Codable {
    var id: String = ""
    var name: String = ""
    let type: UserDefaultsType
    var apiKey: String = ""
    var userDefaults: UserDefaults?

    init(id: String, name: String, type: UserDefaultsType, apiKey: String) {
        self.id = id
        self.name = name
        self.type = type
        self.apiKey = apiKey
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(UserDefaultsType.self, forKey: .type)
        apiKey = try container.decode(String.self, forKey: .apiKey)

        let wrappedUserDefaults = UserDefaults(suiteName: id)
        guard let userDefaults = wrappedUserDefaults else {
            throw InvalidStateError.runtimeError("Error constructing user defaults with key: \(id)")
        }
        self.userDefaults = userDefaults
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(type, forKey: .type)
        try container.encode(apiKey, forKey: .apiKey)
    }

    enum CodingKeys: String, CodingKey {
        case id, name, type, apiKey
    }

    func deleteUserDefaults() throws {
        UserDefaults.standard.removeSuite(named: id)
    }
}

struct SonarUserDefaultsWrapper {
    var userDefaults: SonarUserDefaults
}

extension SonarUserDefaultsWrapper: Codable {
    private enum CodingKeys: CodingKey {
        case type, userDefaults
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(UserDefaultsType.self, forKey: .type)
        userDefaults = try type.metatype.init(from: container.superDecoder(forKey: .userDefaults))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userDefaults.type, forKey: .type)
        try userDefaults.encode(to: container.superEncoder(forKey: .userDefaults))
    }
}
