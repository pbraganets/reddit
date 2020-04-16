//
//  RedditListViewOutput.swift
//  Reddit
//
//  Created by Pavlo B on 16/04/2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

protocol RedditListViewOutput {
    func viewDidLoad(_ view: RedditListViewInput)
    func viewWillRefresh(_ view: RedditListViewInput)
    func viewWillLoadMorePosts(_ view: RedditListViewInput)
    func postDidSelect(_ view: RedditListViewInput, postId: String)
    func shouldLoadMorePosts(_ view: RedditListViewInput) -> Bool
}
