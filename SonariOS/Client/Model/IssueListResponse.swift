//
//  IssueListResponse.swift
//  SonariOS
//
//  Created by Matt Whitaker on 02/09/2024.
//

class IssueListResponse: APIListResponse {
    var items: [Issue]

    override init() {
        items = []
        super.init()
    }

    init(items: [Issue]) {
        self.items = items
        super.init()
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        items = try container.decode([Issue].self, forKey: .items)
        try super.init(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case items = "issues"
    }
}
