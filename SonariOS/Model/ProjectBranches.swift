//
//  ProjectBranches.swift
//  SonariOS
//
//  Created by Matt Whitaker on 07/12/2024.
//
import Foundation

struct ProjectBranchesResponse: Equatable, Decodable {
    let branches: [ProjectBranch]
}

struct ProjectBranch: Equatable, Decodable {
    let name: String
    let isMain: Bool
    let status: ProjectBranchStatus?
    let analysisDate: Date

    // Custom date decoding logic
    private enum CodingKeys: String, CodingKey {
        case name, isMain, status, analysisDate
    }

    // Custom date decoding strategy
    let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()

    init(name: String, isMain: Bool, status: ProjectBranchStatus?, analysisDate: Date) {
        self.name = name
        self.isMain = isMain
        self.status = status
        self.analysisDate = analysisDate
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        isMain = try container.decode(Bool.self, forKey: .isMain)
        status = try container.decodeIfPresent(ProjectBranchStatus.self, forKey: .status)
        let analysisDateString = try container.decode(String.self, forKey: .analysisDate)
        guard let analysisDate = dateFormatter.date(from: analysisDateString) else {
            throw DecodingError.dataCorruptedError(forKey: .analysisDate, in: container, debugDescription: "Invalid date format.")
        }
        self.analysisDate = analysisDate
    }
}

struct ProjectBranchStatus: Equatable, Decodable {
    let qualityGateStatus: String
    let bugs: Int?
    let vulnerabilities: Int?
    let codeSmells: Int?
}
