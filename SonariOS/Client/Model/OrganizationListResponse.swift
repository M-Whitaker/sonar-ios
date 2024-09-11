//
//  OrganizationListResponse.swift
//  SonariOS
//
//  Created by Matt Whitaker on 02/09/2024.
//

class OrganizationListResponse: APIListResponse {
    var items: [Organization]

    init(items: [Organization]) {
        self.items = items
        super.init()
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([Organization].self, forKey: .items)
        try super.init(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case items = "organizations"
    }
}
