//
//  RedditView.swift
//  Reddit
//
//  Created by Pavlo B on 16.04.2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import UIKit

class RedditView<LayoutConfiguration: RedditViewLayout>: UIView {
    
    // MARK: - Public properties
    
    let configuration: LayoutConfiguration
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        self.configuration = LayoutConfiguration()
        super.init(frame: frame)
        configuration.layout(on: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
