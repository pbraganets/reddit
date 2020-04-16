//
//  RedditDetailsViewController.swift
//  Reddit
//
//  Created by Pavlo B on 16/04/2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import UIKit

class RedditDetailsViewController: UIViewController, RedditDetailsViewInput {

    // MARK: - Public properties

    var output: RedditDetailsViewOutput!
    
    // MARK: - Private properties
    
    @UsesAutoLayout private var redditPostView: RedditView<RedditPostLayoutConfiguration> = {
        return RedditView<RedditPostLayoutConfiguration>()
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(redditPostView)
        let layoutConstraints = [
            redditPostView.topAnchor.constraint(equalTo: view.topAnchor),
            redditPostView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            redditPostView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            redditPostView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    // MARK: - RedditDetailsViewInput
    
    func update(with post: RedditPostConfigurationModel) {
        redditPostView.configuration.update(with: post)
    }

}
