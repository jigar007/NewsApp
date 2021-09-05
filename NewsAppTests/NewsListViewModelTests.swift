//
//  NewsListViewModelTests.swift
//  NewsAppTests
//
//  Created by Jigar Thakkar on 5/9/21.
//

import XCTest
@testable import NewsApp

class NewsListViewModelTests: XCTestCase {

    func test_news_fetch_successful() {
        // ARRANGE
        let networkManager = NetworkManager()
        let newListVM = NewsListViewModel(networkManager: networkManager)
        let expectation = self.expectation(description: "ValidRequest_Returns_NewsEnvelope_Response")

        // ACT
        newListVM.fetchNews(perPage: 10, sinceId: 1) { response in
            switch response {
            case .success(let news):
                XCTAssertNotNil(news)
                if type(of: news) != [News].self {
                    XCTFail("Expected news to be a type of array News objects")
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
