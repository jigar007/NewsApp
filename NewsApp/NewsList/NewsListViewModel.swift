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

    func fetchData(completion: @escaping (Result<[News], Error>) -> Void) {

        let urlString = "\(Contants.baseUrlString)\(Contants.AUTopHeadline)&apikey=\(APIKey.key)"
        guard let url = URL(string: urlString) else {
            return
        }

        networkManager?.get(url: url, completionBlock: { result in
            DispatchQueue.main.async {
                switch result {
                case .failure(let error):
                    completion(.failure(error))
                case .success(let data):
                    do {
                        let newsEnvelope = try JSONDecoder.customeDecoder.decode(NewsEnvelope.self, from: data)
                        completion(.success(newsEnvelope.articles))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        })
    }
}
