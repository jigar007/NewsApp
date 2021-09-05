//
//  NetworkManagerTests.swift
//  NewsAppTests
//
//  Created by Jigar Thakkar on 5/9/21.
//

import XCTest
@testable import NewsApp

class NetworkManagerTests: XCTestCase {

    func test_news_envelope_fetch_successful() {
        // ARRANGE
        let networkManager = NetworkManager()
        let expectation = self.expectation(description: "ValidRequest_Returns_NewsEnvelope_Response")

        // ACT
        networkManager.fetchNewsEnvelope(perPage: 10, sinceId: 1) { response in
            switch response {
            case .success(let newsEnvelope):
                XCTAssertNotNil(newsEnvelope)
                if type(of: newsEnvelope) != NewsEnvelope.self {
                    XCTFail("Expected newsEnvelope to be a type of NewsEnvelope")
                }
            case .failure(let error):
                XCTFail("Expected to be a success but got a failure with \(error)")
            }
            expectation.fulfill()
        }

        // ASSERT
        waitForExpectations(timeout: 5, handler: nil)
    }
}
