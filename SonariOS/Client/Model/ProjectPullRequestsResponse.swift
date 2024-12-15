//
//  ProjectPullRequestsResponse.swift
//  SonariOS
//
//  Created by Matt Whitaker on 14/12/2024.
//

struct ProjectPullRequestsResponse: Equatable, Decodable {
    let pullRequests: [PullRequest]
}
