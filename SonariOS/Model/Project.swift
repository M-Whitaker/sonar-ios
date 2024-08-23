//
//  Project.swift
//  SonariOS
//
//  Created by Matt Whitaker on 17/08/2024.
//

import Foundation

struct Project: Equatable, Codable, Identifiable {
    var id: String {
        key
    }

    var key: String
}
