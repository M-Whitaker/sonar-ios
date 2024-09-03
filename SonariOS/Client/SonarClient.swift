//
//  SonarClient.swift
//  SonariOS
//
//  Created by Matt Whitaker on 17/08/2024.
//

import Foundation
import HTTPTypes
import HTTPTypesFoundation

protocol SonarClient {
    var baseUrl: String { get }
    var apiKey: String { get }

    func retrieveIssues(projectKey: String) async throws -> [Issue]
    func retrieveProjects(page: Page) async throws -> ProjectListResponse
}

extension SonarClient {
    func call<T: Decodable>(method: HTTPRequest.Method, path: String) async throws -> T {
        let request = buildRequest(method: method, path: path)
        var wrappedResponse: HTTPResponse?
        var wrappedResponseBody: Data?
        do {
            logRequest(request: request)
            (wrappedResponseBody, wrappedResponse) = try await URLSession.shared.data(for: request)
        } catch {
            print("Some URL Error")
        }

        guard let response = wrappedResponse else {
            print("Response is empty")
            throw APIError.unexpectedResponse
        }
        logResponse(request: request, response: response)

        guard let responseBody = wrappedResponseBody else {
            print("Response body is empty")
            throw APIError.unexpectedResponse
        }

        guard response.status == .ok else {
            print("Response code: \(response.status) is bad")
            throw APIError.httpCode(response.status)
        }
        do {
            print(String(bytes: responseBody, encoding: .utf8) ?? "nil")
            return try JSONDecoder().decode(T.self, from: responseBody)
        } catch is DecodingError {
            print("Decoding error")
            throw APIError.unexpectedResponse
        }
    }

    private func buildRequest(method: HTTPRequest.Method, path: String) -> HTTPRequest {
        var request = HTTPRequest(method: method, scheme: getScheme(), authority: baseUrl, path: path)
        request.headerFields[.accept] = "application/json"
        request.headerFields[.userAgent] = buildUserAgent()
        request.headerFields[.authorization] = buildAuth()
        return request
    }

    private func getScheme() -> String {
        if baseUrl.contains("localhost") {
            "http"
        } else {
            "https"
        }
    }

    private func buildAuth() -> String {
        let loginString = "\(apiKey):"
        let loginData = loginString.data(using: String.Encoding.utf8)!
        return "Basic \(loginData.base64EncodedString())"
    }

    private func buildUserAgent() -> String {
        let appName = Bundle.main.artifactName
        let appVersion = "\(Bundle.main.releaseVersionNumber)-\(Bundle.main.buildVersionNumber)"
        return "\(appName)/\(appVersion)"
    }

    private func logRequest(request: HTTPRequest) {
        print("SENDING \(request.method.rawValue.uppercased()) | headers:\(request.headerFields) | \(request.url?.absoluteString ?? "")")
    }

    private func logResponse(request: HTTPRequest, response: HTTPResponse) {
        print("RECIEVED \(response.status) from \(request.url?.absoluteString ?? "") with headers: \(formatHeaders(headers: response.headerFields, names: .sonarServerTime))")
    }

    private func formatHeaders(headers: HTTPFields, names: HTTPField.Name...) -> String {
        var str = "{"
        for name in names {
            let wrappedVal: String? = headers[name]
            if let val = wrappedVal {
                str.append(" \(name.rawName): \(val)")
            }
        }
        str.append("}")
        return str
    }
}

class StaticSonarClient {
    static var current: SonarClient {
        let type = Preferences.standard.profiles[Preferences.standard.currentProfileIdx].userDefaults.type
        switch type {
        case .sonarQube:
            return SonarQubeClient()
        case .sonarCloud:
            return SonarCloudClient()
        }
    }
}
