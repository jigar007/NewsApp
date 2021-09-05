//
//  ViewController.swift
//  NewsApp
//
//  Created by Jigar Thakkar on 2/9/21.
//

import UIKit

class NewsListViewController: UIViewController {

    private var coordinator: Coordinator?
    private var newsListViewModel: NewsListViewModel

    var newsListView: NewsListView?

    init(coordinator: Coordinator, newsListViewModel: NewsListViewModel) {
        self.coordinator = coordinator
        self.newsListViewModel = newsListViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let newsListView = NewsListView()

        self.newsListView = newsListView
        self.view = newsListView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        newsListViewModel.fetchNews(completion: { [weak self] data in
            switch data {
            case .failure(let error):
                print(error)
            case .success(let data):
                print(data)
            }
        })
    }
}
