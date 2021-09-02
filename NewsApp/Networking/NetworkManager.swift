//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Jigar Thakkar on 2/9/21.
//

import Foundation

protocol NetworkManagerProtocol {
    func get(url: URL, completionBlock: @escaping (Result<Data, Error>) -> Void)
}

class NetworkManager: NetworkManagerProtocol {

    public func get(url: URL, completionBlock: @escaping (Result<Data, Error>) -> Void) {

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, let data = data else {
                completionBlock(.failure(error!))
                return
            }
            completionBlock(.success(data))
        }.resume()
    }
}
