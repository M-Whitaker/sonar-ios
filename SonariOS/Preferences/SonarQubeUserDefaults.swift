//
//  SonarQubeUserDefaults.swift
//  SonariOS
//
//  Created by Matt Whitaker on 27/08/2024.
//

class SonarQubeUserDefaults: SonarUserDefaults {
    var baseUrl = ""

    init(id: String, name: String, apiKey: String, baseUrl: String) {
        super.init(id: id, name: name, type: .sonarQube, apiKey: apiKey)
        self.baseUrl = baseUrl
    }

    required init(from decoder: any Decoder) throws {
        try super.init(from: decoder)
        let container = try decoder.container(keyedBy: CodingKeys.self)
        baseUrl = try container.decode(String.self, forKey: .baseUrl)
    }

    override func encode(to encoder: any Encoder) throws {
        try super.encode(to: encoder)
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(baseUrl, forKey: .baseUrl)
    }

    enum CodingKeys: String, CodingKey {
        case baseUrl
    }
}
