//
//  ProjectStatusTests.swift
//  SonariOS
//
//  Created by Matt Whitaker on 21/09/2024.
//

@testable import SonariOS
import XCTest

final class ProjectStatusTests: XCTestCase {
    func test_Decode_ShouldDecodeSuccessfullyForCloudResponse() throws {
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

        let conditions: [ProjectStatus.RatingCondition] = [.init(status: "OK", metricKey: "new_reliability_rating", comparator: "GT", periodIndex: 1, errorThreshold: "1", actualValue: "1"), .init(status: "OK", metricKey: "new_security_rating", comparator: "GT", periodIndex: 1, errorThreshold: "1", actualValue: "1"), .init(status: "OK", metricKey: "new_maintainability_rating", comparator: "GT", periodIndex: 1, errorThreshold: "1", actualValue: "1"), .init(status: "ERROR", metricKey: "new_coverage", comparator: "LT", periodIndex: 1, errorThreshold: "90", actualValue: "54.89417989417989"), .init(status: "OK", metricKey: "new_duplicated_lines_density", comparator: "GT", periodIndex: 1, errorThreshold: "3", actualValue: "2.0072992700729926"), .init(status: "OK", metricKey: "new_code_smells", comparator: "GT", periodIndex: 1, errorThreshold: "0", actualValue: "0"), .init(status: "OK", metricKey: "new_security_hotspots_reviewed", comparator: "LT", periodIndex: 1, errorThreshold: "100", actualValue: "100.0")]
        let expected = ProjectStatus(status: "ERROR", newRatings: ProjectStatus.NewRatings(conditions: conditions), periods: [.init(index: 1, mode: "previous_version", date: "2024-08-18T00:44:01+0200")])
        XCTAssertEqual(decoded, expected)
    }
  
  func test_Decode_ShouldDecodeSuccessfullyForQubeFirstResponse() throws {
      let body = """
      {
        "projectStatus": {
          "status": "OK",
          "conditions": [],
          "ignoredConditions": false,
          "caycStatus": "compliant"
        }
      }
      """
      let decoded = try JSONDecoder().decode(ProjectStatus.self, from: body.data(using: .utf8)!)
      let expected = ProjectStatus(status: "OK", newRatings: ProjectStatus.NewRatings(conditions: []), periods: [])
      XCTAssertEqual(decoded, expected)
  }
  
  func test_Decode_ShouldDecodeSuccessfullyForQubeSecondResponse() throws {
      let body = """
      {
        "projectStatus": {
          "status": "OK",
          "conditions": [
            {
              "status": "OK",
              "metricKey": "new_violations",
              "comparator": "GT",
              "errorThreshold": "0",
              "actualValue": "0"
            }
          ],
          "ignoredConditions": false,
          "period": {
            "mode": "PREVIOUS_VERSION",
            "date": "2024-09-22T17:12:43+0000"
          },
          "caycStatus": "compliant"
        }
      }
      """
      let decoded = try JSONDecoder().decode(ProjectStatus.self, from: body.data(using: .utf8)!)

      let expected = ProjectStatus(status: "OK", newRatings: ProjectStatus.NewRatings(conditions: []), periods: [.init(index: 0, mode: "PREVIOUS_VERSION", date: "2024-09-22T17:12:43+0000")])
      XCTAssertEqual(decoded, expected)
  }
}
