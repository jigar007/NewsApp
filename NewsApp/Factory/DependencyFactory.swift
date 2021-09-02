//
//  DependencyFactory.swift
//  NewsApp
//
//  Created by Jigar Thakkar on 2/9/21.
//

import Foundation

protocol Factory {
    func makeNewsListViewController(coordinator: AppCoordinator) -> NewsListViewController
}

//// replace the DependencyContainer for tests
class DependencyFactory: Factory {
    func makeInitialCoordinator() -> AppCoordinator {
        let coordinator = AppCoordinator(factory: self)
        return coordinator
    }

    func makeNewsListViewController(coordinator: AppCoordinator) -> NewsListViewController {
        let initialViewController = NewsListViewController(coordinator: coordinator)
        return initialViewController
    }
}
