//
//  ProjectBranches.swift
//  SonariOS
//
//  Created by Matt Whitaker on 07/12/2024.
//
import Foundation

struct ProjectBranch: Equatable, Decodable, Identifiable {
    var id: String {
        branchId
    }

    let name: String
    let isMain: Bool
    let status: ProjectBranchStatus?
    let analysisDate: Date
    let branchId: String

    // Custom date decoding logic
    private enum CodingKeys: String, CodingKey {
        case name, isMain, status, analysisDate, branchId
    }

    // Custom date decoding strategy
    static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    init(name: String, isMain: Bool, status: ProjectBranchStatus?, analysisDate: Date, branchId: String) {
        self.name = name
        self.isMain = isMain
        self.status = status
        self.analysisDate = analysisDate
        self.branchId = branchId
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        isMain = try container.decode(Bool.self, forKey: .isMain)
        branchId = try container.decode(String.self, forKey: .branchId)
        status = try container.decodeIfPresent(ProjectBranchStatus.self, forKey: .status)
        let analysisDateString = try container.decode(String.self, forKey: .analysisDate)
        guard let analysisDate = ProjectBranch.dateFormatter.date(from: analysisDateString) else {
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
