//
//  RedditDetailsPresenter.swift
//  Reddit
//
//  Created by Pavlo B on 16/04/2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

class RedditDetailsPresenter: RedditDetailsModuleInput, RedditDetailsViewOutput, RedditDetailsInteractorOutput {

    // MARK: - Public properties

    weak var view: RedditDetailsViewInput!
    var interactor: RedditDetailsInteractorInput!
    var wireframe: RedditDetailsWireframeInput! {
        didSet {
            wireframe.updateModuleInput(moduleInput: self)
        }
    }
    var postId: String? {
        didSet {
            if let postId = postId, let post = interactor.fetchPost(with: postId) {
                view.update(with: postConfigurationModel(from: post))
            }
        }
    }
    
    // MARK: - Private implementation
    
    private func postConfigurationModel(from post: Post) -> RedditPostConfigurationModel {
        return RedditPostConfigurationModel(id: post.id,
                                            title: post.title,
                                            author: post.author,
                                            date: post.date,
                                            thumbnailUrl: post.thumbnailUrl,
                                            comments: post.comments)
    }

}
