//
//  ProjectBranchesResponse.swift
//  SonariOS
//
//  Created by Matt Whitaker on 08/12/2024.
//

struct ProjectBranchesResponse: Equatable, Decodable {
    let branches: [ProjectBranch]
}
