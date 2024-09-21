//
//  ProjectStatusTests.swift
//  SonariOS
//
//  Created by Matt Whitaker on 21/09/2024.
//

@testable import SonariOS
import XCTest

final class ProjectStatusTests: XCTestCase {
    func test_Decode_Should() throws {
        let body = """
        {
          "projectStatus": {
            "status": "ERROR",
            "conditions": [
              {
                "status": "OK",
                "metricKey": "new_reliability_rating",
                "comparator": "GT",
                "periodIndex": 1,
                "errorThreshold": "1",
                "actualValue": "1"
              },
              {
                "status": "OK",
                "metricKey": "new_security_rating",
                "comparator": "GT",
                "periodIndex": 1,
                "errorThreshold": "1",
                "actualValue": "1"
              },
              {
                "status": "OK",
                "metricKey": "new_maintainability_rating",
                "comparator": "GT",
                "periodIndex": 1,
                "errorThreshold": "1",
                "actualValue": "1"
              },
              {
                "status": "ERROR",
                "metricKey": "new_coverage",
                "comparator": "LT",
                "periodIndex": 1,
                "errorThreshold": "90",
                "actualValue": "54.89417989417989"
              },
              {
                "status": "OK",
                "metricKey": "new_duplicated_lines_density",
                "comparator": "GT",
                "periodIndex": 1,
                "errorThreshold": "3",
                "actualValue": "2.0072992700729926"
              },
              {
                "status": "OK",
                "metricKey": "new_code_smells",
                "comparator": "GT",
                "periodIndex": 1,
                "errorThreshold": "0",
                "actualValue": "0"
              },
              {
                "status": "OK",
                "metricKey": "new_security_hotspots_reviewed",
                "comparator": "LT",
                "periodIndex": 1,
                "errorThreshold": "100",
                "actualValue": "100.0"
              }
            ],
            "periods": [
              {
                "index": 1,
                "mode": "previous_version",
                "date": "2024-08-18T00:44:01+0200"
              }
            ],
            "ignoredConditions": false
          }
        }
        """
        let decoded = try JSONDecoder().decode(ProjectStatus.self, from: body.data(using: .utf8)!)

        let expected = ProjectStatus(status: "ERROR", newReliabilityRating: .init(status: "OK", metricKey: "new_reliability_rating", comparator: "GT", periodIndex: 1, errorThreshold: "1", actualValue: "1"), newSecurityRating: .init(status: "OK", metricKey: "new_security_rating", comparator: "GT", periodIndex: 1, errorThreshold: "1", actualValue: "1"), newMaintainabilityRating: .init(status: "OK", metricKey: "new_maintainability_rating", comparator: "GT", periodIndex: 1, errorThreshold: "1", actualValue: "1"), newCoverage: .init(status: "ERROR", metricKey: "new_coverage", comparator: "LT", periodIndex: 1, errorThreshold: "90", actualValue: "54.89417989417989"), newDuplicatedLinesDensity: .init(status: "OK", metricKey: "new_duplicated_lines_density", comparator: "GT", periodIndex: 1, errorThreshold: "3", actualValue: "2.0072992700729926"), newCodeSmells: .init(status: "OK", metricKey: "new_code_smells", comparator: "GT", periodIndex: 1, errorThreshold: "0", actualValue: "0"), newSecurityHotspotsReviewed: .init(status: "OK", metricKey: "new_security_hotspots_reviewed", comparator: "LT", periodIndex: 1, errorThreshold: "100", actualValue: "100.0"), periods: [.init(index: 1, mode: "previous_version", date: "2024-08-18T00:44:01+0200")])
        XCTAssertEqual(decoded, expected)
    }
}
