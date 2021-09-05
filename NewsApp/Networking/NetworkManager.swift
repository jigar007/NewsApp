//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Jigar Thakkar on 2/9/21.
//

import Foundation

protocol NetworkManagerProtocol {
    func fetchNewsEnvelope(perPage: Int, sinceId: Int, completion: @escaping (Result<NewsEnvelope, APIError>) -> Void)
}

struct NetworkManager: NetworkManagerProtocol {

    private let httpManager = HTTPManager()

    private func createURL(perPage: Int, sinceId: Int) -> URL? {
        var components = URLComponents(string: "\(Contants.baseUrlString)\(Contants.topHeadline)")!

        components.queryItems = [
            URLQueryItem(name: "apikey", value: "\(APIKey.key)"),
            URLQueryItem(name: "pageSize", value: "\(perPage)"),
            URLQueryItem(name: "page", value: "\(sinceId)"),
            URLQueryItem(name: "country", value: "au")
        ]

        return components.url
    }

    func fetchNewsEnvelope(perPage: Int = 10, sinceId: Int, completion: @escaping (Result<NewsEnvelope, APIError>) -> Void) {

        guard let url = createURL(perPage: perPage, sinceId: sinceId) else {
            completion(.failure(.invalidURL))
            return
        }

        httpManager.getDataFor(url: url) { response in
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
