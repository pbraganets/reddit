//
//  RedditDetailsCoordinator.swift
//  Reddit
//
//  Created by Pavlo B on 16/04/2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import UIKit

class RedditDetailsCoordinator: BaseCoordinator, RedditDetailsWireframeInput {
    
    // MARK: - Pubic properties
    
    weak var moduleInput: RedditDetailsModuleInput?

    // MARK: - Private properties

    private let router: Routable
    private var factory: RedditDetailsFactoryProtocol = RedditDetailsFactory()
    private weak var presentable: RedditDetailsViewController?
    private var temporaryPresentable: RedditDetailsViewController?

    // MARK: - Lifecycle

    init(with router: Routable, factory: RedditDetailsFactoryProtocol? = nil) {
        self.router = router
        if let factory = factory {
            self.factory = factory
        }
    }
    
    // MARK: - RedditDetailsWireframeInput
    
    func updateModuleInput(moduleInput: RedditDetailsModuleInput) {
        self.moduleInput = moduleInput
    }

}

// MARK: - Coordinatable

extension RedditDetailsCoordinator: Coordinatable {
    func start() {
        startRedditDetailsModule()
    }

    private func startRedditDetailsModule() {
        temporaryPresentable = factory.createRedditDetailsView(self)
        presentable = temporaryPresentable
    }

}

// MARK: - Presentable

extension RedditDetailsCoordinator: Presentable {
    var viewController: UIViewController? {
        defer {
            temporaryPresentable = nil
        }
        return presentable
    }
}
