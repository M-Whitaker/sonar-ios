//
//  Page.swift
//  SonariOS
//
//  Created by Matt Whitaker on 02/09/2024.
//

struct Page: Codable {
    var pageIndex: Int = 1
    var pageSize: Int = 100
    var total: Int = 0
}
