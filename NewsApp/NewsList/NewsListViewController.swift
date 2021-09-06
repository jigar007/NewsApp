//
//  ViewController.swift
//  NewsApp
//
//  Created by Jigar Thakkar on 2/9/21.
//

import UIKit

class NewsListViewController: UIViewController {

    fileprivate var newsTableViewCellViewModels = [NewsTableViewCellModel]()
    fileprivate var newsList = [News]()
    fileprivate var shouldFetchMoreNews = true

    private var coordinator: Coordinator
    private var newsListViewModel: NewsListViewModel
    private var newsTableViewCellViewModel: NewsTableViewCellViewModel
    private var currentPageId: Int = 1

    private let pageLimit = 10
    private let refreshControl = UIRefreshControl()
    private let spinner = UIActivityIndicatorView()

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self,
                       forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()

    init(coordinator: Coordinator,
         newsListViewModel: NewsListViewModel,
         newsTableViewCellViewModel: NewsTableViewCellViewModel) {
        self.coordinator = coordinator
        self.newsListViewModel = newsListViewModel
        self.newsTableViewCellViewModel = newsTableViewCellViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let label = UILabel()
        label.text = "🇦🇺 News"
        label.font = .systemFont(ofSize: 30, weight: .bold)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: label)
        view.backgroundColor = .systemBackground

        // Add tableview to view
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self

        // Add pull to refresh
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)

        spinner.center = view.center
        spinner.startAnimating()
        view.addSubview(spinner)
        fetchNews()
    }

    @objc private func refresh(_ sender: AnyObject) {
        fetchNews()
    }

    private func fetchNews(){

        newsListViewModel.fetchNews(perPage: pageLimit, sinceId: currentPageId) { [weak self] data in
            guard let self = self else {
                return
            }
            switch data {
            case .success(let news):
                DispatchQueue.main.async {

                    guard !news.isEmpty else {
                        // Need to display end of the news articles
                        self.tableView.tableFooterView = self.createFooterForEndofNews()
                        return
                    }

                    self.newsList.append(contentsOf: news)
                    let newsTableViewCellViewModel = news.compactMap({
                        NewsTableViewCellModel(
                            title: $0.title,
                            subtitle: $0.description ?? "Description not avilable",
                            imageURL: $0.urlToImage
                        )
                    })

                    self.newsTableViewCellViewModels.append(contentsOf: newsTableViewCellViewModel)
                    self.tableView.reloadData()
                    self.tableView.tableFooterView = nil
                    self.refreshControl.endRefreshing()
                    self.spinner.stopAnimating()
                    // Reset it back, so next time on scroll it can fetch more news
                    self.shouldFetchMoreNews = true
                }
            case .failure(let error):
                self.showAlert(withError: error)
            }
        }
    }

    private func showAlert(withError error: APIError) {
        // create the alert
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    private func createSpinenrFooter() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.frame.size.width,
                                              height: 100))

        let spinner = UIActivityIndicatorView()
        spinner.center = footerView.center
        footerView.addSubview(spinner)
        spinner.startAnimating()

        return footerView
    }

    private func createFooterForEndofNews() -> UIView {
        let footerView = UIView(frame: CGRect(x: 0,
                                              y: 0,
                                              width: view.frame.size.width,
                                              height: 100))

        let footerlabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        footerlabel.text = "No new news to load."
        footerlabel.center = footerView.center
        footerView.addSubview(footerlabel)

        return footerView
    }
}

extension NewsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsTableViewCellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: NewsTableViewCell.identifier,
            for: indexPath
        ) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: newsTableViewCellViewModels[indexPath.row], newsTableViewCellViewModel:  newsTableViewCellViewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension NewsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let news = newsList[indexPath.row]
        coordinator.moveToDetail(with: news)
    }
}

extension NewsListViewController: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height

        if offsetY > contentHeight - scrollView.frame.height {

            guard shouldFetchMoreNews else {
                return
            }
            self.tableView.tableFooterView = createSpinenrFooter()

            self.currentPageId = self.currentPageId + 1
            shouldFetchMoreNews = false
            fetchNews()
        }
    }
}
