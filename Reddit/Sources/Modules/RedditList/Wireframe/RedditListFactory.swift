//
//  RedditListFactory.swift
//  Reddit
//
//  Created by Pavlo B on 16/04/2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

protocol RedditListFactoryProtocol {
    func createRedditListView(_ wireframeInput: RedditListWireframeInput) -> RedditListViewController
}

class RedditListFactory: RedditListFactoryProtocol {
    
    func createRedditListView(_ wireframeInput: RedditListWireframeInput) -> RedditListViewController {
        let viewController = RedditListViewController()
        RedditListAssembly.assemble(viewController, wireframeInput: wireframeInput)
        return viewController
    }

}
