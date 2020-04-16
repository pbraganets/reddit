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
    
    private var after: String?
    private var isFetching = false
    private (set) var hasMoreData = true
    
    // MARK: - Lifecycle
    
    private init() { }
    
    // MARK: - Public implementation
    
    func fetchPosts(_ invalidate: Bool, fetchLimit: Int, completionHandler: ((Result<[Post], Swift.Error>) -> Void)? = nil) {
        if invalidate {
            self.invalidate()
        }
        
        guard !isFetching && hasMoreData else {
            return
        }
        
        isFetching = true
        
        RedditFetcher().posts(after: after, limit: fetchLimit)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] completion in
            guard let self = self else {
                return
            }
            self.isFetching = false
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
                
                self.isFetching = false
                self.appendPosts(from: response, completionHandler: completionHandler)
            }
        )
        .store(in: &disposables)
    }
    
    func post(for id: String) -> Post? {
        return posts.first { $0.id == id }
    }
    
    // MARK: - Private implementation
    
    private func appendPosts(from response: RedditResponse, completionHandler: ((Result<[Post], Swift.Error>) -> Void)? = nil) {
        after = response.after
        posts.append(contentsOf: response.posts)
        completionHandler?(.success(self.posts))
    }
    
    private func invalidate() {
        isFetching = false
        after = nil
        posts.removeAll()
    }
    
}
