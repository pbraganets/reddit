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
    
    private var disposables = Set<AnyCancellable>()
    private var cancellable: AnyCancellable?
    @Published private(set) var posts: [Post] = [] {
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
        
        fetch()
    }
    
    // MARK: - Private implementation
    
    private func setupUI() {
        view.backgroundColor = .magenta
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
        return redditPostCell
    }
    
    @objc private func fetch() {
        RedditFetcher().posts(after: nil, limit: 10)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { [weak self] completion in
            guard let self = self else {
                return
            }
            switch completion {
            case .failure:
                self.posts = []
            case .finished:
                break
            }
            },
            receiveValue: { [weak self] response in
                guard let self = self else {
                    return
                }
                self.posts = response.posts
            }
        )
        .store(in: &disposables)
    }
}
    
// MARK: - UITableViewDelegate

extension RedditListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(RedditPostLayoutConfiguration.defaultHeight)
    }
    
}

// MARK: - UITableViewDataSource

extension RedditListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        let redditPostConfigurationModel = RedditPostConfigurationModel(title: post.title,
                                                                        author: post.author,
                                                                        date: post.date,
                                                                        thumbnailUrl: post.thumbnailUrl,
                                                                        comments: post.comments)
        return redditPostCell(for: tableView, configurationModel: redditPostConfigurationModel) ?? UITableViewCell()
    }

}
