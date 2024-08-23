//
//  APIListResponse.swift
//  SonariOS
//
//  Created by Matt Whitaker on 19/08/2024.
//

import Foundation

struct APIListResponse<T: Codable>: Codable {
    var paging: Page
    var components: [T]
}

extension APIListResponse {
    struct Page: Codable {
        var pageIndex: Int
        var pageSize: Int
        var total: Int
    }
}
