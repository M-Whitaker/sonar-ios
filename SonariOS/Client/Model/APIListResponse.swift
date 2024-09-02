//
//  APIListResponse.swift
//  SonariOS
//
//  Created by Matt Whitaker on 19/08/2024.
//

class APIListResponse: Codable {
    var paging: Page = .init(pageIndex: 0, pageSize: 0, total: 0)
}

extension APIListResponse {
    struct Page: Codable {
        var pageIndex: Int
        var pageSize: Int
        var total: Int
    }
}
