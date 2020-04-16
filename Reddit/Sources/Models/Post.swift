//
//  Post.swift
//  Reddit
//
//  Created by Pavel B on 16.04.2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import Foundation

struct Post: Codable {
    let id: String
    let title: String
    let author: String
    let date: Date
    let thumbnailUrl: URL?
    let comments: Int

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case author = "author_fullname"
        case date = "created_utc"
        case thumbnailUrl = "thumbnail"
        case comments = "num_comments"
    }

}
