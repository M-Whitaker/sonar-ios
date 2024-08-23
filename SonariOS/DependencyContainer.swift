//
//  DependencyContainer.swift
//  SonariOS
//
//  Created by Matt Whitaker on 17/08/2024.
//

import Factory

extension Container {
    var sonarClient: Factory<SonarClient> {
        self { SonarCloudClient() }
    }
}
