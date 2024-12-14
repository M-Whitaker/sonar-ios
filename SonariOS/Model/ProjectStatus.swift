//
//  ProjectStatus.swift
//  SonariOS
//
//  Created by Matt Whitaker on 12/09/2024.
//

import Foundation

struct ProjectStatus: Equatable, Decodable {
    var status: String
    var ratings: Ratings = .init(conditions: [])
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
        ratings = try Ratings(conditions: container.decode([RatingCondition].self, forKey: .conditions))
        newRatings = try NewRatings(conditions: container.decode([RatingCondition].self, forKey: .conditions))

        if let period = try container.decodeIfPresent(Period.self, forKey: .period) {
            periods = [period]
        } else {
            periods = try container.decodeIfPresent([Period].self, forKey: .periods) ?? []
        }
    }

    enum RootKeys: CodingKey {
        case projectStatus
    }

    enum CodingKeys: CodingKey {
        case status
        case conditions
        case period
        case periods
    }

    struct Ratings: Equatable {
        var coverage: RatingCondition = .init()
        var codeSmells: RatingCondition = .init()

        init(conditions: [RatingCondition]) {
            for condition in conditions {
                switch condition.metricKey {
                case "coverage":
                    coverage = condition
                case "code_smells":
                    codeSmells = condition
                default:
                    if !condition.metricKey.starts(with: "new_") {
                        print("Unknown key: \(condition.metricKey)")
                    }
                }
            }
        }
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
                    if condition.metricKey.starts(with: "new_") {
                        print("Unknown key: \(condition.metricKey)")
                    }
                }
            }
        }
    }

    struct RatingCondition: Equatable, Codable {
        var status: String
        var metricKey: String
        var comparator: String
        var periodIndex: Int
        var errorThreshold: String
        var actualValue: String
        var value: String {
            switch actualValue {
            case "1":
                "A"
            case "2":
                "B"
            case "3":
                "C"
            case "4":
                "D"
            case "5":
                "E"
            default:
                "?"
            }
        }

        init() {
            status = ""
            metricKey = ""
            comparator = ""
            periodIndex = 0
            errorThreshold = ""
            actualValue = ""
        }

        init(status: String, metricKey: String, comparator: String, periodIndex: Int, errorThreshold: String, actualValue: String) {
            self.status = status
            self.metricKey = metricKey
            self.comparator = comparator
            self.periodIndex = periodIndex
            self.errorThreshold = errorThreshold
            self.actualValue = actualValue
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            status = try container.decode(String.self, forKey: .status)
            metricKey = try container.decode(String.self, forKey: .metricKey)
            comparator = try container.decode(String.self, forKey: .comparator)
            periodIndex = try container.decodeIfPresent(Int.self, forKey: .periodIndex) ?? 0
            errorThreshold = try container.decode(String.self, forKey: .errorThreshold)
            actualValue = try container.decode(String.self, forKey: .actualValue)
        }
    }

    struct Period: Equatable, Codable {
        var index: Int
        var mode: String
        var date: String

        init(index: Int, mode: String, date: String) {
            self.index = index
            self.mode = mode
            self.date = date
        }

        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            index = try container.decodeIfPresent(Int.self, forKey: CodingKeys.index) ?? 0
            mode = try container.decode(String.self, forKey: CodingKeys.mode)
            date = try container.decode(String.self, forKey: CodingKeys.date)
        }
    }
}
