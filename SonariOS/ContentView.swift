//
//  ContentView.swift
//  SonariOS
//
//  Created by Matt Whitaker on 17/08/2024.
//

import Factory
import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Button(action: {
                viewModel.getProjects()
            }, label: {
                Text("Projects")
            })
        }
        .padding()
    }
}

#Preview {
    class SonarClientStub: SonarClient {
        func retrieveProjects() -> [Project] {
            [Project(id: 1)]
        }
    }
    _ = Container.shared.sonarClient.register { SonarClientStub() }
    return Group {
        ContentView()
    }
}
