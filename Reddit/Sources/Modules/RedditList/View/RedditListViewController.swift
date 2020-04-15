//
//  RedditListViewController.swift
//  Reddit
//
//  Created by Pavlo B on 16/04/2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import UIKit

class RedditListViewController: UIViewController, RedditListViewInput {

    // MARK: - Public properties

    var output: RedditListViewOutput!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor.lightGray
    }

}
