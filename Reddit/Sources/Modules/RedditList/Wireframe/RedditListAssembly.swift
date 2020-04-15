//
//  RedditListAssembly.swift
//  Reddit
//
//  Created by Pavlo B on 16/04/2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

class RedditListAssembly {
    static func assemble(_ viewController: RedditListViewController, wireframeInput: RedditListWireframeInput) {
        let presenter = RedditListPresenter()
        presenter.view = viewController
        presenter.wireframe = wireframeInput

        let interactor = RedditListInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }
}
