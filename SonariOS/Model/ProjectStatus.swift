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
      
        init() {
          
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
      
      init (index: Int, mode: String, date: String) {
        self.index = index
        self.mode = mode
        self.date = date
      }
      
      init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.index = try container.decodeIfPresent(Int.self, forKey: CodingKeys.index) ?? 0
        self.mode = try container.decode(String.self, forKey: CodingKeys.mode)
        self.date = try container.decode(String.self, forKey: CodingKeys.date)
      }
    }
}
