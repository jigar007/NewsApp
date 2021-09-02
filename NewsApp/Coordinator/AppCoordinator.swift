//
//  ProjectCoordinator.swift
//  NewsApp
//
//  Created by Jigar Thakkar on 2/9/21.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    func start(_ navigationController: UINavigationController)
    func moveToDetail()
}

class AppCoordinator: Coordinator {

    private var factory: Factory
    weak var navigationController: UINavigationController?

    init(factory: Factory) {
        self.factory = factory
    }

    /// Start the coordinator, intiializing dependencies
    /// - Parameter navigationController: The host UINavigationController
    func start(_ navigationController: UINavigationController) {
        let vc = factory.makeNewsListViewController(coordinator: self)
        self.navigationController = navigationController
        navigationController.pushViewController(vc, animated: true)
    }

    /// Move to the NewsDetailView
    func moveToDetail() {
        let vc = NewsDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}
