//
//  NewsDetailViewController.swift
//  NewsApp
//
//  Created by Jigar Thakkar on 2/9/21.
//

import UIKit
import WebKit

class NewsDetailViewController: UIViewController {

    private var news: News
    private let wkWebView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton

        if let newsURL = news.url {
            wkWebView.frame = view.bounds
            wkWebView.load(URLRequest(url: newsURL))
            view.addSubview(wkWebView)
        } else {
            let newsURLNotAvailable = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 20))
            newsURLNotAvailable.textAlignment = .center
            newsURLNotAvailable.numberOfLines = 0
            newsURLNotAvailable.text = "Source URL for new article is not available"
            newsURLNotAvailable.center = view.center
            view.addSubview(newsURLNotAvailable)
        }
    }

    init(news: News) {
        self.news = news
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
