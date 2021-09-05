//
//  News.swift
//  NewsApp
//
//  Created by Jigar Thakkar on 2/9/21.
//

import Foundation

struct News: Decodable {
    let author: String?
    let title: String
    let description: String?
    let url: URL?
    let urlToImage: URL?
    let publishedAt: Date?
    let content: String?
}

struct NewsEnvelope: Decodable {
    let status: String?
    let totalResults: Int?
    let articles: [News]
}
