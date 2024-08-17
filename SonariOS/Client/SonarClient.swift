//
//  SonarClient.swift
//  SonariOS
//
//  Created by Matt Whitaker on 17/08/2024.
//

import Foundation

protocol SonarClient {
    func retrieveProjects() -> [Project]
}
