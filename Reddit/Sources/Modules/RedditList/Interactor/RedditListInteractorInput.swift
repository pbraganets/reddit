//
//  RedditListInteractorInput.swift
//  Reddit
//
//  Created by Pavlo B on 16/04/2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import Foundation

protocol RedditListInteractorInput {
    func fetchPosts(_ invalidate: Bool, completionHandler: ((Result<[Post], Swift.Error>) -> Void)?)
}
