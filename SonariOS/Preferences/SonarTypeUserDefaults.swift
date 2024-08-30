//
//  SonarTypeUserDefaults.swift
//  SonariOS
//
//  Created by Matt Whitaker on 27/08/2024.
//

import Foundation

enum UserDefaultsType: CaseIterable, Identifiable, CustomStringConvertible {
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

protocol SonarUserDefaults : Identifiable {
  var id: String { get set }
  var name: String { get set }
  var apiKey: String { get set }
  var userDefaults: UserDefaults? { get set }
}

class SonarTypeUserDefaults : SonarUserDefaults, Codable {
  
  let type: UserDefaultsType = .sonarType
  var userDefaults: UserDefaults?
  
  var id = ""
  var name = ""
  var baseUrl = ""
  var apiKey = ""
  
  init() {
    
  }
  
  required init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try container.decode(String.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.baseUrl = try container.decode(String.self, forKey: .baseUrl)
    self.apiKey = try container.decode(String.self, forKey: .apiKey)
    
    let wrappedUserDefaults = UserDefaults(suiteName: self.id)
    guard let userDefaults = wrappedUserDefaults else {
      throw InvalidStateError.runtimeError("Error constructing user defaults with key: \(self.id)")
    }
    self.userDefaults = userDefaults
  }
  
  private enum CodingKeys: String, CodingKey {
      case id, name, baseUrl, apiKey
  }
}
