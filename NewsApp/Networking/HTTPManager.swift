//
//  HTTPManager.swift
//  NewsApp
//
//  Created by Jigar Thakkar on 5/9/21.
//

import Foundation

protocol HTTPManagerProtocol {
    func getDataFor(urlString: String, completion: @escaping (Result<Data, APIError>) -> Void)
}

enum HTTPResponseResult<APIError> {
    case success
    case failure(APIError)
}

enum APIError: Error, Equatable {
    static func == (lhs: APIError, rhs: APIError) -> Bool {
        lhs.self.localizedDescription ==  rhs.self.localizedDescription
    }

    case dataNotDecoded
    case invalidURL
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case unableToDecode
    case notValidResponse
    case responseError(Error?)
}

struct HTTPManager: HTTPManagerProtocol {

    let session = URLSession.shared

    public func getDataFor(urlString: String, completion: @escaping (Result<Data, APIError>) -> Void) {

        guard let url = URL(string: urlString) else {
            return completion(.failure(.invalidURL))
        }

        let dataTask = session.dataTask(with: url) { (data, urlResponse, error) in
            guard error == nil else {
                completion(.failure(.responseError(error)))
                return
            }
            guard let response = urlResponse as? HTTPURLResponse else {
                completion(.failure(.notValidResponse))
                return
            }

            let responseResult = self.handleNetworkResponse(response)

            switch responseResult {
            case .success:
                guard let responseData = data else {
                    completion(.failure(.noData))
                    return
                }
                completion(.success(responseData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }

    private func handleNetworkResponse(_ response: HTTPURLResponse) -> HTTPResponseResult<APIError> {
        switch response.statusCode {
        case 200...299:
            return .success
        case 401...500:
            return .failure(.authenticationError)
        case 501...599:
            return .failure(.badRequest)
        case 600:
            return .failure(.outdated)
        default:
            return .failure(.failed)
        }
    }
}
