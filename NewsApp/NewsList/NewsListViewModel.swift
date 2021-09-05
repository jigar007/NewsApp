//
//  NewsListViewModel.swift
//  NewsApp
//
//  Created by Jigar Thakkar on 2/9/21.
//

import Foundation

final class NewsListViewModel {

    private var networkManager: NetworkManagerProtocol?

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchNews(completion: @escaping (Result<[News], APIError>) -> Void) {

        networkManager?.fetchNewsEnvelope{ response in
            switch response {
            case .success(let newEnvelope):
                completion(.success(newEnvelope.articles))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
