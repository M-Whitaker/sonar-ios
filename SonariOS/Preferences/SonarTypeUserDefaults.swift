//
//  SonarTypeUserDefaults.swift
//  SonariOS
//
//  Created by Matt Whitaker on 27/08/2024.
//

import Foundation

enum UserDefaultsType: CaseIterable, Identifiable, CustomStringConvertible, Codable {
  case sonarType
  case sonarCloud
  
  var id: Self { self }
  var description: String {
    switch self {
      case .sonarType:
        return "Sonar Type"
      case .sonarCloud:
        return "Sonar Cloud"
    }
  }
  
}

enum InvalidStateError: Error {
    case runtimeError(String)
}

class SonarUserDefaults : Identifiable, Codable {
  var id: String = ""
  var name: String = ""
  let type: UserDefaultsType
  var apiKey: String = ""
  var userDefaults: UserDefaults?
  
  init(type: UserDefaultsType) {
    self.type = type
  }
  
  required init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    self.id = try container.decode(String.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.type = try container.decode(UserDefaultsType.self, forKey: .type)
    self.apiKey = try container.decode(String.self, forKey: .apiKey)
    
    let wrappedUserDefaults = UserDefaults(suiteName: self.id)
    guard let userDefaults = wrappedUserDefaults else {
      throw InvalidStateError.runtimeError("Error constructing user defaults with key: \(self.id)")
    }
    self.userDefaults = userDefaults
  }
  
  private enum CodingKeys: String, CodingKey {
      case id, name, type, apiKey
  }
}

class SonarTypeUserDefaults : SonarUserDefaults {

  var baseUrl = ""
  
  init() {
    super.init(type: .sonarType)
  }
  
  required init(from decoder: any Decoder) throws {
    try super.init(from: decoder)
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.baseUrl = try container.decode(String.self, forKey: .baseUrl)
  }
  
  private enum CodingKeys: String, CodingKey {
      case baseUrl
  }
}
