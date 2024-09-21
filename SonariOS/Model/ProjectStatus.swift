//
//  ProjectStatus.swift
//  SonariOS
//
//  Created by Matt Whitaker on 12/09/2024.
//

import Foundation

struct ProjectStatus: Equatable, Decodable {
    var status: String
    var newReliabilityRating: RatingCondition = .init()
    var newSecurityRating: RatingCondition = .init()
    var newMaintainabilityRating: RatingCondition = .init()
    var newCoverage: RatingCondition = .init()
    var newDuplicatedLinesDensity: RatingCondition = .init()
    var newCodeSmells: RatingCondition = .init()
    var newSecurityHotspotsReviewed: RatingCondition = .init()
    var periods: [Period]

    init(status: String, newReliabilityRating: RatingCondition, newSecurityRating: RatingCondition, newMaintainabilityRating: RatingCondition, newCoverage: RatingCondition, newDuplicatedLinesDensity: RatingCondition, newCodeSmells: RatingCondition, newSecurityHotspotsReviewed: RatingCondition, periods: [Period]) {
        self.status = status
        self.newReliabilityRating = newReliabilityRating
        self.newSecurityRating = newSecurityRating
        self.newMaintainabilityRating = newMaintainabilityRating
        self.newCoverage = newCoverage
        self.newDuplicatedLinesDensity = newDuplicatedLinesDensity
        self.newCodeSmells = newCodeSmells
        self.newSecurityHotspotsReviewed = newSecurityHotspotsReviewed
        self.periods = periods
    }

    init(from decoder: any Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        let container = try rootContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .projectStatus)
        status = try container.decode(String.self, forKey: .status)
        let conditions = try container.decode([RatingCondition].self, forKey: .conditions)

        for condition in conditions {
            switch condition.metricKey {
            case "new_reliability_rating":
                newReliabilityRating = condition
            case "new_security_rating":
                newSecurityRating = condition
            case "new_maintainability_rating":
                newMaintainabilityRating = condition
            case "new_coverage":
                newCoverage = condition
            case "new_duplicated_lines_density":
                newDuplicatedLinesDensity = condition
            case "new_code_smells":
                newCodeSmells = condition
            case "new_security_hotspots_reviewed":
                newSecurityHotspotsReviewed = condition
            default:
                throw URLError(.callIsActive)
            }
        }

        periods = try container.decode([Period].self, forKey: .periods)
    }

    enum RootKeys: CodingKey {
        case projectStatus
    }

    enum CodingKeys: CodingKey {
        case status
        case conditions
        case periods
    }

    struct RatingCondition: Equatable, Codable {
        var status: String = ""
        var metricKey: String = ""
        var comparator: String = ""
        var periodIndex: Int = 0
        var errorThreshold: String = ""
        var actualValue: String = ""
    }

    struct Period: Equatable, Codable {
        var index: Int
        var mode: String
        var date: String
    }
}
