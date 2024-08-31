//
//  SonarCloudUserDefaults.swift
//  SonariOS
//
//  Created by Matt Whitaker on 29/08/2024.
//

import Foundation

class SonarCloudUserDefaults : SonarUserDefaults {
  
  init(id: String, name: String, apiKey: String) {
    super.init(id: id, name: name, type: .sonarCloud, apiKey: apiKey)
  }
  
  required init(from decoder: any Decoder) throws {
    try super.init(from: decoder)
  }
}
