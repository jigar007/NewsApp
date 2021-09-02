//
//  ViewController.swift
//  NewsApp
//
//  Created by Jigar Thakkar on 2/9/21.
//

import UIKit

class NewsListViewController: UIViewController {

    private var coordinator: Coordinator?

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        button.center = view.center
        button.backgroundColor = .systemBlue
        button.setTitle("Go to detail view", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        view.addSubview(button)

        view.backgroundColor = .red
    }

    @objc func pressed() {
        coordinator?.moveToDetail()
    }
}
