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
    func makeInitialCoordinator() -> AppCoordinator {
        let coordinator = AppCoordinator(factory: self)
        return coordinator
    }

    func makeNewsListViewController(coordinator: AppCoordinator) -> NewsListViewController {
        let newsListViewModel = makeNewsListViewModel(coordinator: coordinator)
        let newsViewController = NewsListViewController(coordinator: coordinator,
                                                        newsListViewModel: newsListViewModel)
        return newsViewController
    }

    func makeNewsListViewModel(coordinator: Coordinator) -> NewsListViewModel {
        let newsListViewModel = NewsListViewModel()
        return newsListViewModel
    }
}
