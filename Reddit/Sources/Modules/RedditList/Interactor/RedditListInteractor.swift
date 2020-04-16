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
    private var disposables = Set<AnyCancellable>()
    private var cancellable: AnyCancellable?
    private var posts: [Post] = []
    
    // MARK: - RedditListInteractorInput
    
    func fetchPosts(_ invalidate: Bool, completionHandler: ((Result<[Post], Swift.Error>) -> Void)? = nil) {
        if invalidate {
            posts.removeAll()
        }
        
        RedditFetcher().posts(after: nil, limit: fetchLimit)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] completion in
            guard self != nil else {
                return
            }
            switch completion {
            case .failure(let error):
                completionHandler?(.failure(error))
            case .finished:
                break
            }
            },
            receiveValue: { [weak self] response in
                guard let self = self else {
                    return
                }
                self.appendPosts(response.posts, completionHandler: completionHandler)
            }
        )
        .store(in: &disposables)
    }
    
    // MARK: - Private implementation
    
    private func appendPosts(_ posts: [Post], completionHandler: ((Result<[Post], Swift.Error>) -> Void)? = nil) {
        self.posts.append(contentsOf: posts)
        completionHandler?(.success(self.posts))
    }

}
