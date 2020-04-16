//
//  RedditDetailsAssembly.swift
//  Reddit
//
//  Created by Pavlo B on 16/04/2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

class RedditDetailsAssembly {
    static func assemble(_ viewController: RedditDetailsViewController, wireframeInput: RedditDetailsWireframeInput) {
        let presenter = RedditDetailsPresenter()
        presenter.view = viewController
        presenter.wireframe = wireframeInput

        let interactor = RedditDetailsInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }
}
