//
//  RedditPostLayoutConfiguration.swift
//  Reddit
//
//  Created by Pavel B on 16.04.2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import UIKit

struct RedditPostConfigurationModel {
    let id: String
    let title: String
    let author: String
    let date: Date
    let thumbnailUrl: URL?
    let comments: Int
}

final class RedditPostLayoutConfiguration: RedditViewLayout {
    
    static let reuseIdentifier = String(describing: RedditPostLayoutConfiguration.self)
    static let defaultHeight: Float = 105.0
    
    // MARK: - Private properties
    
    @UsesAutoLayout private var backgroundView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    @UsesAutoLayout private var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    @UsesAutoLayout private var commentsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .ultraLight)
        label.textColor = .white
        return label
    }()
    
    @UsesAutoLayout private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4.0
        return imageView
    }()
    
    @UsesAutoLayout private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    @UsesAutoLayout private var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    private var layoutConstraints = [NSLayoutConstraint]()
    
    // MARK: - RedditViewLayout
    
    init() {
        backgroundView.addSubview(authorLabel)
        backgroundView.addSubview(commentsLabel)
        backgroundView.addSubview(imageView)
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(dateLabel)
    }
    
    func layout(on view: UIView) {
        NSLayoutConstraint.deactivate(layoutConstraints)
        layoutConstraints.removeAll()
        
        backgroundView.removeFromSuperview()
        view.addSubview(backgroundView)
        let backgroundViewConstraints = [
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        layoutConstraints += backgroundViewConstraints
        
        commentsLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let authorLabelConstraints = [
            authorLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16.0),
            authorLabel.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16.0),
            authorLabel.trailingAnchor.constraint(equalTo: commentsLabel.leadingAnchor, constant: -16.0)
        ]
        layoutConstraints += authorLabelConstraints
        
        commentsLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        let commentsLabelConstraints = [
            commentsLabel.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 16.0),
            commentsLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16.0)
        ]
        layoutConstraints += commentsLabelConstraints
        
        let imageViewConstraints = [
            imageView.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 14.0),
            imageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 16.0),
            imageView.widthAnchor.constraint(equalToConstant: 48.0),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ]
        layoutConstraints += imageViewConstraints
        
        let titleToDateAlighment = titleLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor, constant: -10.0)
        titleToDateAlighment.priority = .init(100)
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 2.0),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12.0),
            titleToDateAlighment,
            titleLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16.0)
        ]
        layoutConstraints += titleLabelConstraints
        
        let dateToImageAlighmentConstraint = dateLabel.bottomAnchor.constraint(greaterThanOrEqualTo: imageView.bottomAnchor, constant: -2.0)
        dateToImageAlighmentConstraint.priority = .init(300)
        let dateLabelConstraints = [
            dateLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12.0),
            dateLabel.bottomAnchor.constraint(lessThanOrEqualTo: backgroundView.bottomAnchor, constant: -16.0),
            dateToImageAlighmentConstraint,
            dateLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -16.0)
        ]
        layoutConstraints += dateLabelConstraints
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    func update(with model: RedditPostConfigurationModel) {
        authorLabel.text = model.author
        commentsLabel.text = String(model.comments)
        titleLabel.text = model.title
        dateLabel.text = model.date.description
        if let imageUrl = model.thumbnailUrl {
            imageView.setImage(with: imageUrl, placeholder: nil)
        } else {
            imageView.image = nil
        }
    }
    
}
