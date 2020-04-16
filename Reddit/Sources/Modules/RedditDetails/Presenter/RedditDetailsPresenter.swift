//
//  RedditDetailsPresenter.swift
//  Reddit
//
//  Created by Pavlo B on 16/04/2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

class RedditDetailsPresenter: RedditDetailsModuleInput, RedditDetailsViewOutput, RedditDetailsInteractorOutput {

    // MARK: - Public properties

    weak var view: RedditDetailsViewInput!
    var interactor: RedditDetailsInteractorInput!
    var wireframe: RedditDetailsWireframeInput!

}
