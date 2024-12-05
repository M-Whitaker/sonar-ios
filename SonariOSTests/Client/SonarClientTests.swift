//
//  SonarClientTests.swift
//  SonariOSTests
//
//  Created by Matt Whitaker on 11/09/2024.
//

@testable import SonariOS
import XCTest

final class SonarHttpClientTests: XCTestCase {
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

        let classUnderTest = SonarHttpClient(urlSession: urlSession)

        let obj: ExampleResponse = try await classUnderTest.call(baseUrl: "example.com", apiKey: "key_12345", method: .get, path: "/path/to/resource")

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

        let classUnderTest = SonarHttpClient(urlSession: urlSession)

        try await assertThrowsAsyncError(await classUnderTest.call(baseUrl: "example.com", apiKey: "key_12345", method: .get, path: "/path/to/resource", type: ExampleResponse.self)) { error in
            XCTAssertEqual(error as! APIError, APIError.httpCode(.notFound))
        }
    }

    func test_ShouldThrowAPIErrorUnexpectedResponseWhenDecodingErrorKeyNotFound() async throws {
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
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return (response, data)
        }

        let classUnderTest = SonarHttpClient(urlSession: urlSession)

        try await assertThrowsAsyncError(await classUnderTest.call(baseUrl: "example.com", apiKey: "key_12345", method: .get, path: "/path/to/resource", type: ExampleResponse.self)) { error in
            XCTAssertEqual(error as! APIError, APIError.unexpectedResponse)
        }
    }

    func test_ShouldThrowAPIErrorUnexpectedResponseWhenDecodingErrorValueNotFound() async throws {
        var urlSession: URLSession {
            let configuration: URLSessionConfiguration = .ephemeral
            configuration.protocolClasses = [MockURLProtocol.self]
            return URLSession(configuration: configuration)
        }

        let response = """
          {
            "foo": null
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

        let classUnderTest = SonarHttpClient(urlSession: urlSession)

        try await assertThrowsAsyncError(await classUnderTest.call(baseUrl: "example.com", apiKey: "key_12345", method: .get, path: "/path/to/resource", type: ExampleResponse.self)) { error in
            XCTAssertEqual(error as! APIError, APIError.unexpectedResponse)
        }
    }

    struct ExampleResponse: Codable {
        var foo: String
    }
}
