//
//  ProjectBranchTests.swift
//  SonariOS
//
//  Created by Matt Whitaker on 08/12/2024.
//

@testable import SonariOS
import XCTest

final class ProjectBranchTests: XCTestCase {
    func test_Decode_ShouldDecodeSuccessfullyForCloudResponse() throws {
        let body = """
        {
          "name": "master",
          "isMain": true,
          "type": "LONG",
          "status": {
            "qualityGateStatus": "OK",
            "bugs": 1,
            "vulnerabilities": 2,
            "codeSmells": 0
          },
          "analysisDate": "2024-12-06T20:41:27+0100",
          "commit": {
            "sha": "b2adbffa2698587135b473f9d71eb6d0d5dad23c",
            "author": {
              "name": "Matt Whitaker",
              "login": "M-Whitaker@github",
              "avatar": "8b1bf854fa562f41603a44d62b586dcb"
            },
            "date": "2024-12-06T20:35:12+0100",
            "message": "Merge pull request #6 from M-Whitaker/feature/enable-codeql"
          },
          "branchId": "ba1c19d0-9dbb-4a70-ab03-a0059e825f62"
        }
        """
        let decoded = try JSONDecoder().decode(ProjectBranch.self, from: body.data(using: .utf8)!)
        let expected = ProjectBranch(name: "master", isMain: true, status: ProjectBranchStatus(qualityGateStatus: "OK", bugs: 1, vulnerabilities: 2, codeSmells: 0), analysisDate: Date(timeIntervalSince1970: TimeInterval(1_733_514_087)))
        XCTAssertEqual(decoded, expected)
    }

    func test_Decode_ShouldDecodeSuccessfullyForQubeResponse() throws {
        let body = """
        {
          "name": "branch-3.4.1-lts",
          "isMain": false,
          "type": "BRANCH",
          "status": { "qualityGateStatus": "OK" },
          "analysisDate": "2021-12-03T21:12:08+0000",
          "excludedFromPurge": true,
          "branchId": "AX2CJSGtUqFHQDDY7ryg"
        }
        """
        let decoded = try JSONDecoder().decode(ProjectBranch.self, from: body.data(using: .utf8)!)
        let expected = ProjectBranch(name: "branch-3.4.1-lts", isMain: false, status: ProjectBranchStatus(qualityGateStatus: "OK", bugs: nil, vulnerabilities: nil, codeSmells: nil), analysisDate: Date(timeIntervalSince1970: TimeInterval(1_638_565_928)))
        XCTAssertEqual(decoded, expected)
    }

    func test_Decode_ShouldThrowForInvalidDateFormatResponse() {
        let body = """
        {
          "name": "branch-3.4.1-lts",
          "isMain": false,
          "type": "BRANCH",
          "status": { "qualityGateStatus": "OK" },
          "analysisDate": "2021-12-0321:12:08+0000",
          "excludedFromPurge": true,
          "branchId": "AX2CJSGtUqFHQDDY7ryg"
        }
        """
        XCTAssertThrowsError(try JSONDecoder().decode(ProjectBranch.self, from: body.data(using: .utf8)!)) { error in
            XCTAssertEqual((error as? DecodingError)?.localizedDescription, "The data couldn’t be read because it isn’t in the correct format.")
        }
    }
}
