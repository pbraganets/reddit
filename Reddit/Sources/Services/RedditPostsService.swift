//
//  RedditPostsService.swift
//  Reddit
//
//  Created by Pavel B on 16.04.2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import Foundation
import Combine

final class RedditPostsService {
    
    // MARK: - Public properties
    
    static let shared = RedditPostsService()
    
    // MARK: - Private properties
    
    private var disposables = Set<AnyCancellable>()
    private var cancellable: AnyCancellable?
    private var posts: [Post] = []
    
    private init() { }
    
    // MARK: - Public implementation
    
    func fetchPosts(_ invalidate: Bool, fetchLimit: Int, completionHandler: ((Result<[Post], Swift.Error>) -> Void)? = nil) {
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
    
    func post(for id: String) -> Post? {
        return posts.first { $0.id == id }
    }
    
    // MARK: - Private implementation
    
    private func appendPosts(_ posts: [Post], completionHandler: ((Result<[Post], Swift.Error>) -> Void)? = nil) {
        self.posts.append(contentsOf: posts)
        completionHandler?(.success(self.posts))
    }
    
}
