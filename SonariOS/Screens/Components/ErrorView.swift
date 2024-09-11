//
//  ErrorView.swift
//  SonariOS
//
//  Created by Matt Whitaker on 02/09/2024.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let retryAction: () async -> Void

    @State var isRefreshing = false

    var body: some View {
        VStack {
            Text("An Error Occured")
                .font(.title)
            Text(error.localizedDescription)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40).padding()
            retryButton()
        }
    }

    private func retryButton() -> some View {
        Button(action: {
            Task {
                isRefreshing = true
                await retryAction()
                isRefreshing = false
            }
        }, label: { Text("Retry").bold() })
            .disabled(isRefreshing)
    }
}
