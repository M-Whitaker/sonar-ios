//
//  Project.swift
//  SonariOS
//
//  Created by Matt Whitaker on 17/08/2024.
//

struct Project: Equatable, Decodable, Identifiable {
    var id: String {
        key
    }

    var key: String
    var name: String
    var organization: String
    var status: ProjectStatus?

    enum CodingKeys: CodingKey {
        case key
        case name
        case organization
    }
}
