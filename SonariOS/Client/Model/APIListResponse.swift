//
//  APIListResponse.swift
//  SonariOS
//
//  Created by Matt Whitaker on 19/08/2024.
//

class APIListResponse: Codable {
    var paging: Page

    init() {
        paging = Page()
    }
}
