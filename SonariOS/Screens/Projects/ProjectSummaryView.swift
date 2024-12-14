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
        if let status = project.status {
            VStack {
                HStack {
                    Text("\(project.organization.map { "\($0)/\(project.name)" } ?? project.name)")
                        .bold()
                    Spacer()
                    if status.status == "OK" {
                        Image(systemName: "checkmark")
                            .bold()
                            .background(Color.green)
                        Text("Passed")
                            .bold()
                    } else {
                        Image(systemName: "xmark")
                            .bold()
                            .background(Color.red)
                        Text("Failed")
                            .bold()
                    }
                }
                Divider()
                HStack {
                    Text("Security")
                    ratingIcon(status.newRatings.securityRating.value)
                    Text("Reliability")
                    ratingIcon(status.newRatings.reliabilityRating.value)
                    Text("Maintainability")
                    ratingIcon(status.newRatings.maintainabilityRating.value)
                }
                HStack {
                    Text("Hotspots Reviewed")
                    Text("\(status.newRatings.securityHotspotsReviewed.actualValue)%")
                    Text("Coverage")
                    Text("\(status.ratings.coverage.actualValue)%")
                    Text("Duplications")
                    Text("\(String(format: "%.2f", Double(status.newRatings.duplicatedLinesDensity.actualValue) ?? 0))%")
                }
            }
        }
    }

    private func ratingIcon(_ value: String) -> some View {
        ZStack {
            Image(systemName: "circle.fill")
                .foregroundStyle(.green)
            Text(value)
                .foregroundStyle(.black)
        }
    }
}
