//
//  Organization.swift
//  SonariOS
//
//  Created by Matt Whitaker on 01/09/2024.
//

struct Organization: Equatable, Codable, Identifiable {
    var id: String {
        key
    }

    var key: String
}
