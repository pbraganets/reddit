//
//  MainCoordinator.swift
//  Reddit
//
//  Created by Pavlo B on 16.04.2020.
//  Copyright © 2019 Pavlo B. All rights reserved.
//

import Foundation

class MainCoordinator: BaseCoordinator, Coordinatable {
    
    // MARK: - Private properties
    
    private let router: Routable
    
    // MARK: - Lifecycle

    init(with router: Routable) {
        self.router = router
    }
    
    // MARK: - Coordinatable

    func start() {
        let redditListCoordinator = RedditListCoordinator(with: router)
        addDependency(redditListCoordinator)
        redditListCoordinator.start()
        router.setRoot(redditListCoordinator, animated: false)
    }
}
