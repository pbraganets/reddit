//
//  RedditListPresenter.swift
//  Reddit
//
//  Created by Pavlo B on 16/04/2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

class RedditListPresenter: RedditListModuleInput, RedditListViewOutput, RedditListInteractorOutput {

    // MARK: - Public properties

    weak var view: RedditListViewInput!
    var interactor: RedditListInteractorInput!
    var wireframe: RedditListWireframeInput!

}
