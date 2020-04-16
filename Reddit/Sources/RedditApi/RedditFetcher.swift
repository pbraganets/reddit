//
//  RedditFetcher.swift
//  Reddit
//
//  Created by Pavel B on 16.04.2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import Foundation
import Combine

enum RedditFetcherError: Error {
  case parsing(description: String)
  case network(description: String)
}

protocol RedditFetchable {
    func posts(after: String?, limit: Int) -> AnyPublisher<RedditResponse, RedditFetcherError>
}

class RedditFetcher {
    
    // MARK: - Private implementation
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
}

// MARK: - CryptoRatesFetchable

extension RedditFetcher: RedditFetchable {
    
    func posts(after: String?, limit: Int) -> AnyPublisher<RedditResponse, RedditFetcherError> {
        guard let url = redditComponents(after: after, limit: limit).url else {
            return Fail(error: RedditFetcherError.network(description: "Couldn't create URL")).eraseToAnyPublisher()
        }
        return session.dataTaskPublisher(for: URLRequest(url: url))
            .mapError { error in
                .network(description: error.localizedDescription)
        }
        .flatMap(maxPublishers: .max(1)) { pair in
            self.decode(pair.data)
        }
        .eraseToAnyPublisher()
    }
    
    private func decode<T: Decodable>(_ data: Data) -> AnyPublisher<T, RedditFetcherError> {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        return Just(data)
            .decode(type: T.self, decoder: decoder)
            .mapError { error in
                .parsing(description: error.localizedDescription)
        }
        .eraseToAnyPublisher()
    }
    
}

// MARK: - RedditApi

private extension RedditFetcher {
    struct RedditApi {
        static let scheme = "https"
        static let host = "www.reddit.com"
        static let path = "/r/all/top/.json"
    }
    
    func redditComponents(after: String?, limit: Int) -> URLComponents {
        var components = URLComponents()
        components.scheme = RedditApi.scheme
        components.host = RedditApi.host
        components.path = RedditApi.path
        components.query = "t=all&limit=\(limit)"
        if let after = after {
            components.query = components.path + "&after=\(after)"
        }
        
        return components
    }
    
}
