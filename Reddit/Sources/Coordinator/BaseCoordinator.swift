//
//  BaseCoordinator.swift
//  Reddit
//
//  Created by Pavlo B on 16.04.2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import Foundation

class BaseCoordinator {
    
    // MARK: - Private properties
    
    private var childCoordinators: [Coordinatable] = []
    
    // MARK: - Public implemenation
    
    func addDependency(_ coordinator: Coordinatable) {
        for element in childCoordinators where element === coordinator {
            return
        }
        childCoordinators.append(coordinator)
    }
    
    func removeDependency(_ coordinator: Coordinatable?) {
        guard childCoordinators.isEmpty == false, let coordinator = coordinator else {
            return
        }
        
        for (index, element) in childCoordinators.enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }
}
