//
//  BundleData.swift
//  SonariOS
//
//  Created by Matt Whitaker on 21/08/2024.
//

import Foundation

extension Bundle {
    var releaseVersionNumber: String {
        infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
    }

    var buildVersionNumber: String {
        infoDictionary?["CFBundleVersion"] as? String ?? "unknown"
    }

    var artifactName: String {
        Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "unknown"
    }
}
