//
//  SonarTypeClient.swift
//  SonariOS
//
//  Created by Matt Whitaker on 17/08/2024.
//

import Foundation

class SonarTypeClient: SonarClient {
    func retrieveProjects() -> [Project] {
        print("Retriving projects from sonar type...")
        return [Project(id: 1)]
    }
}
