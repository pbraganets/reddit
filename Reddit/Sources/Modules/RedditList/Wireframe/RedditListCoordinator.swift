//
//  RedditListCoordinator.swift
//  Reddit
//
//  Created by Pavlo B on 16/04/2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import UIKit

class RedditListCoordinator: BaseCoordinator, RedditListWireframeInput {

    // MARK: - Private properties

    private let router: Routable
    private var factory: RedditListFactoryProtocol = RedditListFactory()
    private weak var presentable: RedditListViewController?
    private var temporaryPresentable: RedditListViewController?

    // MARK: - Lifecycle

    init(with router: Routable, factory: RedditListFactoryProtocol? = nil) {
        self.router = router
        if let factory = factory {
            self.factory = factory
        }
    }
    
    // MARK: - RedditListWireframeInput
    
    func performDisplayDetails(postId: String) {
        startRedditDetailsModule(with: postId)
    }

}

// MARK: - Coordinatable

extension RedditListCoordinator: Coordinatable {
    func start() {
        startRedditListModule()
    }

    private func startRedditListModule() {
        temporaryPresentable = factory.createRedditListView(self)
        presentable = temporaryPresentable
    }
    
    private func startRedditDetailsModule(with postId: String) {
        let redditDetailsCoordinator = RedditDetailsCoordinator(with: router)
        redditDetailsCoordinator.start()
        redditDetailsCoordinator.moduleInput?.postId = postId
        addDependency(redditDetailsCoordinator)
        router.push(redditDetailsCoordinator, animated: true) {
            self.removeDependency(redditDetailsCoordinator)
        }
    }

}

// MARK: - Presentable

extension RedditListCoordinator: Presentable {
    var viewController: UIViewController? {
        defer {
            temporaryPresentable = nil
        }
        return presentable
    }
}
