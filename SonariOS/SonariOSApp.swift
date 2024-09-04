//
//  SonariOSApp.swift
//  SonariOS
//
//  Created by Matt Whitaker on 17/08/2024.
//

import SwiftUI

@main
struct AppLauncher {
    static func main() throws {
        if NSClassFromString("XCTestCase") == nil {
            SonariOSApp.main()
        } else {
            TestApp.main()
        }
    }
}

struct TestApp: App {
    var body: some Scene {
        WindowGroup { Text("Running Unit Tests") }
    }
}

struct SonariOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
