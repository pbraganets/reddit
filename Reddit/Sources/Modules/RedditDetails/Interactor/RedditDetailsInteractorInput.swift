//
//  RedditDetailsInteractorInput.swift
//  Reddit
//
//  Created by Pavlo B on 16/04/2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import Foundation

protocol RedditDetailsInteractorInput {
    func fetchPost(with id: String) -> Post?
}
