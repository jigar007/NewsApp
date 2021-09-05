//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Jigar Thakkar on 2/9/21.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchNewsEnvelope(completion: @escaping (Result<NewsEnvelope, APIError>) -> Void)
}

struct NetworkManager: NetworkManagerProtocol {

    private let httpManager = HTTPManager()

    func fetchNewsEnvelope(completion: @escaping (Result<NewsEnvelope, APIError>) -> Void) {

        let urlString = "\(Contants.baseUrlString)\(Contants.AUTopHeadline)&apikey=\(APIKey.key)&pageSize=10"

        httpManager.getDataFor(urlString: urlString) { response in
            switch response {
            case  .success(let data):
                do {
                    let newsEnvelope = try JSONDecoder.customeDecoder.decode(NewsEnvelope.self, from: data)
                    completion(.success(newsEnvelope))
                } catch {
                    completion(.failure(.dataNotDecoded))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
