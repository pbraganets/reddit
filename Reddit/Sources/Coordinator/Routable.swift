//
//  Routable.swift
//  Reddit
//
//  Created by Pavlo B on 16.04.2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import Foundation

typealias RouterCompletion = (() -> Void)

protocol Routable: class {
    func present(_ presentable: Presentable?, animated: Bool)
    func push(_ presentable: Presentable, animated: Bool, completion: RouterCompletion?)
    func pop(animated: Bool)
    func setRoot(_ presentable: Presentable, animated: Bool)
    func popToRoot(animated: Bool)
    func popTo(_ presentable: Presentable, animated: Bool)
}
