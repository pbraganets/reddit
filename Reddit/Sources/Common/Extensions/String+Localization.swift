//
//  String+Localization.swift
//  Reddit
//
//  Created by Pavel B on 16.04.2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import Foundation

import UIKit

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
