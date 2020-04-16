//
//  RedditListViewController.swift
//  Reddit
//
//  Created by Pavlo B on 16/04/2020.
//  Copyright © 2020 Pavlo B. All rights reserved.
//

import UIKit
import Combine

class RedditListViewController: UIViewController, RedditListViewInput {

    // MARK: - Public properties

    var output: RedditListViewOutput!
    
    private var posts: [RedditPostConfigurationModel] = [] {
        didSet {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    // MARK: - Private properties
    
    static private let tintColor = UIColor(red:0.25, green:0.72, blue:0.85, alpha:1.0)
    
    @UsesAutoLayout private var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = tintColor
        return refreshControl
    }()
    
    @UsesAutoLayout private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = tintColor
        return tableView
    }()
    
    @UsesAutoLayout private var bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    @UsesAutoLayout private var dismissAllButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(tintColor, for: .normal)
        button.setTitle("Dismiss all".localized, for: .normal)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        output.viewDidLoad(self)
    }
    
    // MARK: - RedditListViewInput
    
    func update(with posts: [RedditPostConfigurationModel]) {
        self.posts = posts
    }
    
    // MARK: - Private implementation
    
    private func setupUI() {
        view.backgroundColor = .black
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: RedditListViewController.tintColor]
        title = "Reddit".localized
        
        setupTableView()
        setupDismissAllButton()
        
        layout()
    }
    
    private func layout() {
        var layoutConstraints = [NSLayoutConstraint]()
        
        view.addSubview(tableView)
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        layoutConstraints += tableViewConstraints
        
        view.addSubview(bottomContainerView)
        let bottomContainerViewConstraints = [
            bottomContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bottomContainerView.heightAnchor.constraint(equalToConstant: 68.0 + (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)),
            bottomContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        layoutConstraints += bottomContainerViewConstraints
        
        bottomContainerView.addSubview(dismissAllButton)
        let dismissAllButtonButtonConstraints = [
            dismissAllButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -16.0),
            dismissAllButton.topAnchor.constraint(equalTo: bottomContainerView.topAnchor, constant: 12.0),
            dismissAllButton.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 16.0),
            dismissAllButton.heightAnchor.constraint(equalToConstant: 44.0)
        ]
        layoutConstraints += dismissAllButtonButtonConstraints
        
        NSLayoutConstraint.activate(layoutConstraints)
    }
    
    private func setupTableView() {
        tableView.register(RedditTableViewCell<RedditPostLayoutConfiguration>.self,
                           forCellReuseIdentifier: RedditPostLayoutConfiguration.reuseIdentifier)
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(fetch), for: .valueChanged)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = CGFloat(RedditPostLayoutConfiguration.defaultHeight)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupDismissAllButton() {
        dismissAllButton.addTarget(self, action: #selector(dismissAll(_:)), for: .touchUpInside)
    }
    
    @objc private func dismissAll(_ sender: UIButton) {
        
    }
    
    private func redditPostCell(for tableView: UITableView,
                              configurationModel: RedditPostConfigurationModel)
        -> RedditTableViewCell<RedditPostLayoutConfiguration>? {
            
        let reuseIdentifier = RedditPostLayoutConfiguration.reuseIdentifier
        guard let redditPostCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier)
            as? RedditTableViewCell<RedditPostLayoutConfiguration> else {
                return nil
        }

        redditPostCell.configuration.update(with: configurationModel)
        redditPostCell.selectionStyle = .none
        redditPostCell.backgroundColor = .black
        return redditPostCell
    }
    
    @objc private func fetch() {
        output.viewWillRefresh(self)
    }
}
    
// MARK: - UITableViewDelegate

extension RedditListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output.postDidSelect(self, postId: posts[indexPath.row].id)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == posts.count - 1 && output.shouldLoadMorePosts(self) {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.frame = CGRect(x: 0.0,
                                   y: 0.0,
                                   width: tableView.bounds.width,
                                   height: 44.0)
            spinner.startAnimating()
            tableView.tableFooterView = spinner
            tableView.tableFooterView?.isHidden = false

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.output.viewWillLoadMorePosts(self)
            }
        } else {
            tableView.tableFooterView?.removeFromSuperview()
            let view = UIView()
            view.frame = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 5.0)
            tableView.tableFooterView = view
            tableView.tableFooterView?.isHidden = true
        }
    }
    
}

// MARK: - UITableViewDataSource

extension RedditListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let redditPostConfigurationModel = posts[indexPath.row]
        return redditPostCell(for: tableView, configurationModel: redditPostConfigurationModel) ?? UITableViewCell()
    }

}
