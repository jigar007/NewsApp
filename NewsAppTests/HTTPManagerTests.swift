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
        let urlString = "\(Contants.baseUrlString)\(Contants.AUTopHeadline)&apikey=\(APIKey.key)"
        let expectation = self.expectation(description: "ValidRequest_Returns_Data_Response")

        // ACT
        httpManager.getDataFor(urlString: urlString) { response in
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
        let urlString = "\(Contants.baseUrlString)\(Contants.AUTopHeadline)"

        let expectation = self.expectation(description: "InRequest_Returns_Invalid_Response")

        // ACT
        httpManager.getDataFor(urlString: urlString) { response in
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
