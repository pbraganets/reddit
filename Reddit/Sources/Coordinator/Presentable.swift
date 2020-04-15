//
//  Presentable.swift
//  Reddit
//
//  Created by Pavlo B on 16.04.2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import UIKit

protocol Presentable {
    var viewController: UIViewController? { get }
}

extension UIViewController: Presentable {
    var viewController: UIViewController? {
        return self
    }
    
}
