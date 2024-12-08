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
    func retrieveProjects(page: Page) async throws -> ProjectListResponse
    func retrieveProjectStatusFor(projectKey: String) async throws -> ProjectStatus
    func retrieveCurrentUser() async throws -> User
    func retrieveIssues(page: Page) async throws -> IssueListResponse
    func retrieveBranches(projectKey: String) async throws -> [ProjectBranch]
    func retrieveEffort(projectKey: String) async throws -> Effort
}

class SonarHttpClient {
    private var urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func call<T: Decodable>(baseUrl: String, apiKey: String, method: HTTPRequest.Method, path: String, type _: T.Type = T.self) async throws -> T {
        let request = buildRequest(baseUrl: baseUrl, apiKey: apiKey, method: method, path: path)
        var wrappedResponse: HTTPResponse?
        var wrappedResponseBody: Data?
        logRequest(request: request)
        (wrappedResponseBody, wrappedResponse) = try await urlSession.data(for: request)

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
            return try JSONDecoder().decode(T.self, from: responseBody)
        } catch let error as DecodingError {
            print("Decoding error for object: (\(T.self))...")
            switch error {
            case let .typeMismatch(key, value), let .valueNotFound(key, value):
                print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
            case let .keyNotFound(key, value):
                print("error \(key), value \(value) and ERROR: \(error.localizedDescription)")
            case let .dataCorrupted(key):
                print("error \(key), and ERROR: \(error.localizedDescription)")
            default:
                print("ERROR: \(error.localizedDescription)")
            }
            print(String(decoding: responseBody, as: Unicode.UTF8.self))
            throw APIError.unexpectedResponse
        }
    }

    private func buildRequest(baseUrl: String, apiKey: String, method: HTTPRequest.Method, path: String) -> HTTPRequest {
        var request = HTTPRequest(method: method, scheme: getScheme(baseUrl: baseUrl), authority: baseUrl, path: path)
        request.headerFields[.accept] = "application/json"
        request.headerFields[.userAgent] = buildUserAgent()
        request.headerFields[.authorization] = buildAuth(apiKey: apiKey)
        return request
    }

    private func getScheme(baseUrl: String) -> String {
        if baseUrl.contains("localhost") {
            "http"
        } else {
            "https"
        }
    }

    private func buildAuth(apiKey: String) -> String {
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
