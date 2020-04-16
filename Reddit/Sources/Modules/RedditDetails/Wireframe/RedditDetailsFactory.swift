//
//  RedditDetailsFactory.swift
//  Reddit
//
//  Created by Pavlo B on 16/04/2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

protocol RedditDetailsFactoryProtocol {
    func createRedditDetailsView(_ wireframeInput: RedditDetailsWireframeInput) -> RedditDetailsViewController
}

class RedditDetailsFactory: RedditDetailsFactoryProtocol {
    
    func createRedditDetailsView(_ wireframeInput: RedditDetailsWireframeInput) -> RedditDetailsViewController {
        let viewController = RedditDetailsViewController()
        RedditDetailsAssembly.assemble(viewController, wireframeInput: wireframeInput)
        return viewController
    }

}
