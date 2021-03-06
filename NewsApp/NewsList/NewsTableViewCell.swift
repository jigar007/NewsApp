//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Jigar Thakkar on 3/9/21.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    static let identifier = "NewsTableViewCell"

    private let newsTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13, weight: .light)
        return label
    }()

    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(newsImageView)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        newsTitleLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.frame.size.width - 170,
            height: 70
        )
        subtitleLabel.frame = CGRect(
            x: 10,
            y: 70,
            width: contentView.frame.size.width - 170,
            height: contentView.frame.size.height/2
        )

        newsImageView.frame = CGRect(
            x: contentView.frame.size.width-150,
            y: 5,
            width: 140,
            height: contentView.frame.size.height - 10
        )
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        newsTitleLabel.text = nil
        subtitleLabel.text = nil
        newsImageView.image = nil
        newsImageView.isHidden = false
    }

    func configure(with viewModel: NewsTableViewCellModel, newsTableViewCellViewModel: NewsTableViewCellViewModel) {
        newsTitleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle

        //TODO: This method needs to move to network layer

        // Image
        if let image = viewModel.imageData {
            newsImageView.image = image
        }
        else if let url = viewModel.imageURL {
            newsTableViewCellViewModel.fetchImage(withURL: url) { [weak self] response in
                switch response{
                case .success(let imageData):
                    viewModel.imageData = imageData
                case.failure:
                    DispatchQueue.main.async {
                        self?.newsImageView.isHidden = true
                    }
                }
            }

        } else {
            newsImageView.isHidden = true
        }
    }
}
