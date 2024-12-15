//
//  PullRequest.swift
//  SonariOS
//
//  Created by Matt Whitaker on 14/12/2024.
//
import Foundation

struct PullRequest: Equatable, Decodable, Identifiable {
    var id: String {
        key
    }

    let key: String
    let title: String
    let branch: String
    let base: String
    let status: ProjectBranchStatus?
    let analysisDate: Date
    let url: String
    let target: String

    enum CodingKeys: CodingKey {
        case key
        case title
        case branch
        case base
        case status
        case analysisDate
        case url
        case target
    }

    // Custom date decoding strategy
    static let dateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        return formatter
    }()

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        key = try container.decode(String.self, forKey: .key)
        title = try container.decode(String.self, forKey: .title)
        branch = try container.decode(String.self, forKey: .branch)
        base = try container.decode(String.self, forKey: .base)
        status = try container.decodeIfPresent(ProjectBranchStatus.self, forKey: .status)
        let analysisDateString = try container.decode(String.self, forKey: .analysisDate)
        guard let analysisDate = ProjectBranch.dateFormatter.date(from: analysisDateString) else {
            throw DecodingError.dataCorruptedError(forKey: .analysisDate, in: container, debugDescription: "Invalid date format.")
        }
        self.analysisDate = analysisDate
        url = try container.decode(String.self, forKey: .url)
        target = try container.decode(String.self, forKey: .target)
    }
}
