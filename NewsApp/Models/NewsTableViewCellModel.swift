//
//  NewsTableViewCellModel.swift
//  NewsApp
//
//  Created by Jigar Thakkar on 6/9/21.
//

import Foundation
import UIKit

class NewsTableViewCellModel {
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: UIImage? = nil

    init(
        title: String,
        subtitle: String,
        imageURL: URL?
    ) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL

    }
}
