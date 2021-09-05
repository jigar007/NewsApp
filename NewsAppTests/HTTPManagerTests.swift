//
//  NewsAppTests.swift
//  NewsAppTests
//
//  Created by Jigar Thakkar on 2/9/21.
//

import XCTest
@testable import NewsApp

class HTTPManagerTests: XCTestCase {

    func test_successful_url_request() {

        // ARRANGE
        let httpManager = HTTPManager()

        var components = URLComponents(string: "\(Contants.baseUrlString)\(Contants.topHeadline)")!
        components.queryItems = [
            URLQueryItem(name: "apikey", value: "\(APIKey.key)"),
            URLQueryItem(name: "country", value: "au")
        ]
        guard let url = components.url else {
            return
        }

        let expectation = self.expectation(description: "ValidRequest_Returns_Data_Response")

        // ACT
        httpManager.getDataFor(url: url) { response in
            switch response {
            case .success(let value):
                XCTAssertNotNil(value)
            case .failure(let error):
                XCTFail("Expected to be a success but got a failure with \(error)")
            }
            expectation.fulfill()
        }

        // ASSERT
        waitForExpectations(timeout: 5, handler: nil)
    }

    func test_without_api_key_url_request() {

        // ARRANGE
        let httpManager = HTTPManager()
        guard let url = URL(string: "\(Contants.baseUrlString)\(Contants.topHeadline)") else {
            return
        }

        let expectation = self.expectation(description: "InRequest_Returns_Invalid_Response")

        // ACT
        httpManager.getDataFor(url: url) { response in
            switch response {
            case .success(let value):
                XCTAssertNil(value)
                XCTFail("Expected to be a failure but got a success with \(value)")
            case .failure(let error):
                XCTAssertEqual(error, .authenticationError)
            }
            expectation.fulfill()
        }

        // ASSERT
        waitForExpectations(timeout: 5, handler: nil)
    }
}
