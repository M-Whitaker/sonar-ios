//
//  Issue.swift
//  SonariOS
//
//  Created by Matt Whitaker on 18/08/2024.
//

struct Issue: Equatable, Decodable, Identifiable {
    var id: String {
        key
    }

    var key: String
    let rule: String
    let severity: String
    let component: String

    enum CodingKeys: CodingKey {
        case key
        case rule
        case severity
        case component
    }
}
