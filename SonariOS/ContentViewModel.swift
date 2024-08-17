//
//  ContentViewModel.swift
//  SonariOS
//
//  Created by Matt Whitaker on 17/08/2024.
//

import Factory
import Foundation

class ContentViewModel: ObservableObject {
    @Injected(\.sonarClient) var sonarClient

    func getProjects() -> [Project] {
        sonarClient.retrieveProjects()
    }
}
