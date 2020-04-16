//
//  RedditDetailsInteractor.swift
//  Reddit
//
//  Created by Pavlo B on 16/04/2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

class RedditDetailsInteractor: RedditDetailsInteractorInput {

    // MARK: - Public properties

    weak var output: RedditDetailsInteractorOutput!
    
    // MARK: - RedditDetailsInteractorInput
    
    func fetchPost(with id: String) -> Post? {
        return RedditPostsService.shared.post(for: id)
    }

}
