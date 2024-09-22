//
//  ProjectSummaryView.swift
//  SonariOS
//
//  Created by Matt Whitaker on 12/09/2024.
//

import SwiftUI

struct ProjectSummaryView: View {
    var project: Project

    var body: some View {
        VStack {
            Text("\(project.organization.map({ "\($0)/\(project.name)" }) ?? project.name)")
            if let status = project.status {
                Text(status.status)
                Text(status.newRatings.coverage.actualValue)
            }
        }
    }
}
