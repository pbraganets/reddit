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
