//
//  DependencyFactory.swift
//  NewsApp
//
//  Created by Jigar Thakkar on 2/9/21.
//

import Foundation

protocol Factory {
    func makeNewsListViewController(coordinator: AppCoordinator) -> NewsListViewController
    func makeNewsListViewModel(coordinator: Coordinator) -> NewsListViewModel
}

//// replace the DependencyContainer for tests
class DependencyFactory: Factory {

    var networkManager: NetworkManagerProtocol = NetworkManager()

    func makeInitialCoordinator() -> AppCoordinator {
        AppCoordinator(factory: self)
    }

    func makeNewsListViewController(coordinator: AppCoordinator) -> NewsListViewController {
        let newsListViewModel = makeNewsListViewModel(coordinator: coordinator)
        let newsTableViewCellViewModel = makeNewsTableViewCellViewModel(coordinator: coordinator)
        let newsViewController = NewsListViewController(coordinator: coordinator,
                                                        newsListViewModel: newsListViewModel,
                                                        newsTableViewCellViewModel: newsTableViewCellViewModel)
        return newsViewController
    }

    func makeNewsListViewModel(coordinator: Coordinator) -> NewsListViewModel {
       NewsListViewModel(networkManager: networkManager)
    }
    
    func makeNewsTableViewCellViewModel(coordinator: Coordinator) -> NewsTableViewCellViewModel {
        NewsTableViewCellViewModel(networkManager: networkManager)
    }
}
