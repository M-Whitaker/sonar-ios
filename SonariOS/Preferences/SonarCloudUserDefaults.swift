//
//  SonarCloudUserDefaults.swift
//  SonariOS
//
//  Created by Matt Whitaker on 29/08/2024.
//

import Foundation

class SonarCloudUserDefaults : SonarUserDefaults {
  
  init() {
    super.init(type: .sonarCloud)
  }
  
  required init(from decoder: any Decoder) throws {
    try super.init(from: decoder)
  }
}
