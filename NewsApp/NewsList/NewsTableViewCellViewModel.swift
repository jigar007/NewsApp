//
//  NewsTableViewCellViewModel.swift
//  NewsApp
//
//  Created by Jigar Thakkar on 6/9/21.
//

import Foundation
import UIKit

final class NewsTableViewCellViewModel {

    private var networkManager: NetworkManagerProtocol?

    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }

    func fetchImage(withURL url: URL, completion: @escaping (Result<UIImage, APIError>) -> Void) {

        networkManager?.fetchImageData(withURL: url) { response in
            switch response {
            case .success(let imageData):
                completion(.success(imageData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
