//
//  OrganizationListResponseTests.swift
//  SonariOSTests
//
//  Created by Matt Whitaker on 08/09/2024.
//

@testable import SonariOS
import XCTest

final class OrganizationListResponseTests: XCTestCase {
    func test_Decode_Should() throws {
        let body = """
        {
            "organizations": [
                {
                    "key": "my-org",
                    "name": "My Org",
                    "description": "My Organization Description",
                    "url": "https://example.com",
                    "avatar": "https://avatars.githubusercontent.com/u/9919?s=200&v=4",
                    "alm": {
                        "key": "github",
                        "url": "https://github.com/my-org",
                        "personal": true,
                        "membersSync": false
                    },
                    "actions": {
                        "admin": true,
                        "delete": true,
                        "provision": true
                    },
                    "subscription": "FREE",
                    "onlyPrivateProjects": {
                        "enabled": false,
                        "available": false
                    }
                }
            ],
            "paging": {
                "pageIndex": 1,
                "pageSize": 100,
                "total": 1
            }
        }
        """
        let decoded = try JSONDecoder().decode(OrganizationListResponse.self, from: body.data(using: .utf8)!)

        let expected = OrganizationListResponse(items: [Organization(key: "my-org")])
        XCTAssertEqual(decoded.items, expected.items)
        XCTAssertEqual(decoded.paging, Page(pageIndex: 1, pageSize: 100, total: 1))
    }
}
