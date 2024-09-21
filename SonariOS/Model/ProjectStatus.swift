//
//  ProjectStatus.swift
//  SonariOS
//
//  Created by Matt Whitaker on 12/09/2024.
//

import Foundation

struct ProjectStatus: Equatable, Decodable {
    var status: String
    var newRatings: NewRatings = .init(conditions: [])
    var periods: [Period]

    init(status: String, newRatings: NewRatings, periods: [Period]) {
        self.status = status
        self.newRatings = newRatings
        self.periods = periods
    }

    init(from decoder: any Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        let container = try rootContainer.nestedContainer(keyedBy: CodingKeys.self, forKey: .projectStatus)
        status = try container.decode(String.self, forKey: .status)
        newRatings = try NewRatings(conditions: container.decode([RatingCondition].self, forKey: .conditions))

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

    struct NewRatings: Equatable {
        var reliabilityRating: RatingCondition = .init()
        var securityRating: RatingCondition = .init()
        var maintainabilityRating: RatingCondition = .init()
        var coverage: RatingCondition = .init()
        var duplicatedLinesDensity: RatingCondition = .init()
        var codeSmells: RatingCondition = .init()
        var securityHotspotsReviewed: RatingCondition = .init()

        init(conditions: [RatingCondition]) {
            for condition in conditions {
                switch condition.metricKey {
                case "new_reliability_rating":
                    reliabilityRating = condition
                case "new_security_rating":
                    securityRating = condition
                case "new_maintainability_rating":
                    maintainabilityRating = condition
                case "new_coverage":
                    coverage = condition
                case "new_duplicated_lines_density":
                    duplicatedLinesDensity = condition
                case "new_code_smells":
                    codeSmells = condition
                case "new_security_hotspots_reviewed":
                    securityHotspotsReviewed = condition
                default:
                    print("Unknown key: \(condition.metricKey)")
                }
            }
        }
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
