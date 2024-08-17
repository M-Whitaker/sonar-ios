//
//  SonarCloudClient.swift
//  SonariOS
//
//  Created by Matt Whitaker on 17/08/2024.
//

import Foundation

class SonarCloudClient: SonarClient {
    func retrieveProjects() -> [Project] {
        print("Retriving projects from sonar cloud...")
        return [Project(id: 1)]
    }
}
