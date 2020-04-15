//
//  Router.swift
//  Reddit
//
//  Created by Pavlo B on 16.04.2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import UIKit

class Router: NSObject, Routable {

    // MARK: - Private properties
    
    private let navigationController: UINavigationController
    private var completions: [UIViewController: RouterCompletion] = [:]

    // MARK: - Lifecycle
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        navigationController.delegate = self
    }

    // MARK: - Routable
    
    func present(_ presentable: Presentable?, animated: Bool) {
        guard let controller = presentable?.viewController else {
            return
        }
        navigationController.present(controller, animated: animated, completion: nil)
    }
    
    func push(_ presentable: Presentable, animated: Bool, completion: RouterCompletion?) {
        guard let viewController = presentable.viewController else {
            return
        }

        if let completion = completion {
            completions.updateValue(completion, forKey: viewController)
        }
        navigationController.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool) {
        if let controller = navigationController.popViewController(animated: animated) {
            executeClosure(for: controller)
        }
    }
    
    func setRoot(_ presentable: Presentable, animated: Bool) {
        guard let controller = presentable.viewController else {
            return
        }
        navigationController.setViewControllers([controller], animated: animated)
    }
    
    func popToRoot(animated: Bool) {
        if let controllers = navigationController.popToRootViewController(animated: animated) {
            controllers.forEach { controller in
                executeClosure(for: controller)
            }
        }
    }
    
    func popTo(_ presentable: Presentable, animated: Bool) {
        guard let controller = presentable.viewController else {
            return
        }
        if let controllers = navigationController.popToViewController(controller, animated: animated) {
            controllers.forEach { controller in
                executeClosure(for: controller)
            }
        }
    }
    
    // MARK: - Private implementation

    private func executeClosure(for viewController: UIViewController) {
        guard let completion = completions.removeValue(forKey: viewController) else {
            return
        }
        completion()
    }
}

// MARK: - UINavigationControllerDelegate

extension Router: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(previousController) else {
                return
        }
        executeClosure(for: previousController)
    }
}
