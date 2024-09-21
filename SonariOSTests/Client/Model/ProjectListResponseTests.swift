//
//  ProjectListResponseTests.swift
//  SonariOSTests
//
//  Created by Matt Whitaker on 08/09/2024.
//

@testable import SonariOS
import XCTest

final class ProjectListResponseTests: XCTestCase {
    func test_Decode_Should() throws {
        let body = """
        {
            "paging": {
                "pageIndex": 1,
                "pageSize": 1,
                "total": 42
            },
            "components": [
                {
                    "organization": "my-org",
                    "key": "some_repository",
                    "name": "repository",
                    "qualifier": "TRK",
                    "project": "some_repository"
                }
            ]
        }
        """
        let decoded = try JSONDecoder().decode(ProjectListResponse.self, from: body.data(using: .utf8)!)

        let expected = ProjectListResponse(items: [Project(key: "some_repository", name: "repository", organization: "my-org")])
        XCTAssertEqual(decoded.items, expected.items)
        XCTAssertEqual(decoded.paging, Page(pageIndex: 1, pageSize: 1, total: 42))
    }
}
