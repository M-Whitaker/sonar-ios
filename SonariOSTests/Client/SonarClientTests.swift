//
//  SonarClientTests.swift
//  SonariOSTests
//
//  Created by Matt Whitaker on 11/09/2024.
//

@testable import SonariOS
import XCTest

final class SonarClientTests: XCTestCase {
    func test_Call_ShouldSendHttpRequestWithCorrectParamsAndDecodeResponseSuccessfullyWhenStatusCode200() async throws {
        var urlSession: URLSession {
            let configuration: URLSessionConfiguration = .ephemeral
            configuration.protocolClasses = [MockURLProtocol.self]
            return URLSession(configuration: configuration)
        }

        let response = """
          {
            "foo": "bar"
          }
        """
        let data = response.data(using: .utf8)!
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://theiosdude.api.com/test")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, data)
        }

        let classUnderTest = SonarCloudTestingStub(baseUrl: "example.com", apiKey: "key_12345", urlSession: urlSession)

        let obj: ExampleResponse = try await classUnderTest.call(method: .get, path: "/path/to/resource")

        XCTAssertEqual(obj.foo, "bar")
    }

    func test_Call_ShouldThrowAPIErrorHttpCodeWhenResponseCodeIsNot200() async throws {
        var urlSession: URLSession {
            let configuration: URLSessionConfiguration = .ephemeral
            configuration.protocolClasses = [MockURLProtocol.self]
            return URLSession(configuration: configuration)
        }

        let response = """
          {
            "error": "resource not found"
          }
        """
        let data = response.data(using: .utf8)!
        MockURLProtocol.error = nil
        MockURLProtocol.requestHandler = { _ in
            let response = HTTPURLResponse(url: URL(string: "https://theiosdude.api.com/test")!,
                                           statusCode: 404,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, data)
        }

        let classUnderTest = SonarCloudTestingStub(baseUrl: "example.com", apiKey: "key_12345", urlSession: urlSession)

        try await assertThrowsAsyncError(await classUnderTest.call(method: .get, path: "/path/to/resource", type: ExampleResponse.self)) { error in
            XCTAssertEqual(error as! APIError, APIError.httpCode(.notFound))
        }
    }

    struct ExampleResponse: Codable {
        var foo: String
    }

    class SonarCloudTestingStub: SonarClient {
        var baseUrl: String
        var apiKey: String
        var urlSession: URLSession

        init(baseUrl: String, apiKey: String, urlSession: URLSession) {
            self.baseUrl = baseUrl
            self.apiKey = apiKey
            self.urlSession = urlSession
        }

        func retrieveIssues(projectKey _: String) async throws -> [SonariOS.Issue] {
            []
        }

        func retrieveProjects(page _: Page) async throws -> SonariOS.ProjectListResponse {
            ProjectListResponse()
        }

        func retrieveProjectStatusFor(projectKey _: String) async throws -> SonariOS.ProjectStatus {
            try ProjectStatus(from: JSONDecoder() as! Decoder)
        }
    }
}
