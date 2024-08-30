//
//  SonarCloudUserDefaults.swift
//  SonariOS
//
//  Created by Matt Whitaker on 29/08/2024.
//

import Foundation

class SonarCloudUserDefaults : SonarUserDefaults, Codable {
  
  let type: UserDefaultsType = .sonarCloud
  var userDefaults: UserDefaults?
  
  var id = ""
  var name = ""
  var apiKey = ""
  
  init() {
    
  }
  
  required init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    self.id = try container.decode(String.self, forKey: .id)
    self.name = try container.decode(String.self, forKey: .name)
    self.apiKey = try container.decode(String.self, forKey: .apiKey)
    
    let wrappedUserDefaults = UserDefaults(suiteName: self.id)
    guard let userDefaults = wrappedUserDefaults else {
      throw InvalidStateError.runtimeError("Error constructing user defaults with key: \(self.id)")
    }
    self.userDefaults = userDefaults
  }
  
  private enum CodingKeys: String, CodingKey {
      case id, name, apiKey
  }
}
