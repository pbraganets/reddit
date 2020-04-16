//
//  RedditListPresenter.swift
//  Reddit
//
//  Created by Pavlo B on 16/04/2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

class RedditListPresenter: RedditListModuleInput, RedditListViewOutput, RedditListInteractorOutput {

    // MARK: - Public properties

    weak var view: RedditListViewInput!
    var interactor: RedditListInteractorInput!
    var wireframe: RedditListWireframeInput!
    
    // MARK: - RedditListViewOutput
    
    func viewDidLoad(_ view: RedditListViewInput) {
        fetchPosts(true)
    }
    
    func viewWillRefresh(_ view: RedditListViewInput) {
        fetchPosts(true)
    }
    
    func viewWillLoadMorePosts(_ view: RedditListViewInput) {
        fetchPosts(false)
    }
    
    func viewWillInvalidate(_ view: RedditListViewInput) {
        invalidatePosts()
    }
    
    func postDidSelect(_ view: RedditListViewInput, postId: String) {
        // TODO: post should be marked as read via Interactor
        
        wireframe.performDisplayDetails(postId: postId)
    }
    
    func shouldLoadMorePosts(_ view: RedditListViewInput) -> Bool {
        return true // TODO: should be retrieved form Interactor
    }
    
    // MARK: - Private implementation
    
    private func fetchPosts(_ invalidate: Bool) {
        interactor.fetchPosts(invalidate) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let posts):
                self.view.update(with: posts.map({ (post) -> RedditPostConfigurationModel in
                    return RedditPostConfigurationModel(id: post.id,
                                                        title: post.title,
                                                        author: post.author,
                                                        date: post.date,
                                                        thumbnailUrl: post.thumbnailUrl,
                                                        comments: post.comments)
                }))
            case .failure(_):
                break
            }
        }
    }
    
    private func invalidatePosts() {
        interactor.invalidatePosts { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let posts):
                self.view.update(with: posts.map({ (post) -> RedditPostConfigurationModel in
                    return RedditPostConfigurationModel(id: post.id,
                                                        title: post.title,
                                                        author: post.author,
                                                        date: post.date,
                                                        thumbnailUrl: post.thumbnailUrl,
                                                        comments: post.comments)
                }))
            case .failure(_):
                break
            }
        }
    }

}
