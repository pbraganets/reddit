//
//  RedditTableViewCell.swift
//  Reddit
//
//  Created by Pavlo B on 16.04.2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import UIKit

class RedditTableViewCell<LayoutConfiguration: RedditViewLayout>: UITableViewCell {
    
    // MARK: - Public properties
    
    let configuration: LayoutConfiguration
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.configuration = LayoutConfiguration()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configuration.layout(on: contentView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
