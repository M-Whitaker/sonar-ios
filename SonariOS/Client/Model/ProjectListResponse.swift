//
//  ProjectListResponse.swift
//  SonariOS
//
//  Created by Matt Whitaker on 02/09/2024.
//

class ProjectListResponse: APIListResponse {
    var items: [Project]

    override init() {
        items = []
        super.init()
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([Project].self, forKey: .items)
        try super.init(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case items = "components"
    }
}
