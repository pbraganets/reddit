//
//  RedditResponse.swift
//  Reddit
//
//  Created by Pavel B on 16.04.2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import Foundation

struct RedditResponse: Codable {
    struct PostData: Codable {
        let data: Post
    }
    
    let after: String
    let posts: [Post]
    
    enum CodingKeys: String, CodingKey {
        case after
        case posts = "data"
        
        enum DataKeys: String, CodingKey {
            case after
            case children
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dataContainer = try container.nestedContainer(keyedBy: CodingKeys.DataKeys.self, forKey: .posts)
        after = try dataContainer.decode(String.self, forKey: .after)
        let postsData = try dataContainer.decode([PostData].self, forKey: .children)
        posts = postsData.map { $0.data }
    }
    
}
