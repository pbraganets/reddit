//
//  RedditListInteractor.swift
//  Reddit
//
//  Created by Pavlo B on 16/04/2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import Foundation
import Combine

class RedditListInteractor: RedditListInteractorInput {

    // MARK: - Public properties

    weak var output: RedditListInteractorOutput!
    
    // MARK: - Private properties
    
    let fetchLimit = 10
    
    // MARK: - RedditListInteractorInput
    
    func fetchPosts(_ invalidate: Bool, completionHandler: ((Result<[Post], Swift.Error>) -> Void)? = nil) {
        RedditPostsService.shared.fetchPosts(invalidate, fetchLimit: fetchLimit, completionHandler: completionHandler)
    }

}
