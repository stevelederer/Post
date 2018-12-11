//
//  PostListViewController.swift
//  Post
//
//  Created by Steve Lederer on 12/10/18.
//  Copyright © 2018 Steve Lederer. All rights reserved.
//

import UIKit

class PostListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK: - Properties
    let postController = PostController()
    
    var refreshControl = UIRefreshControl()
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // setting tableViewCells dynamic heights
        tableView.estimatedRowHeight = 45
        tableView.rowHeight = UITableView.automaticDimension
        
        // setting up refresh control for tableView
        tableView.refreshControl = refreshControl
        
        // setting refreshControl to call the refreshControlPulled function when user swipes down on the top of the tableView
        refreshControl.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        PostController.fetchPosts {
            self.reloadTableView()
        }
    }
    
    // MARK: - Helper Methods
    @objc func refreshControlPulled() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        PostController.fetchPosts {
            self.reloadTableView()
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    // Custom reload table view function
    func reloadTableView() {
        DispatchQueue.main.async {
            // add networkActivityIndicator to the reloadView function
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.tableView.reloadData()
        }
    }
    // alert controller to create new post
    func presentNewPostAlert() {
        let newPostAlertController = UIAlertController(title: "Add Post", message: "Enter information here:", preferredStyle: .alert)
        newPostAlertController.addTextField { (usernameTextField) in
            usernameTextField.placeholder = "Enter Username"
        }
        newPostAlertController.addTextField { (messageTextField) in
            messageTextField.placeholder = "Enter Message..."
        }
        
        let postAction = UIAlertAction(title: "Post", style: .default) { (postAction) in
            guard let username = newPostAlertController.textFields?.first?.text, !username.isEmpty, let text = newPostAlertController.textFields?[1].text, !text.isEmpty else { self.presentErrorAlert() ; return }
            PostController.addNewPostWith(username: username, text: text, completion: {
                self.reloadTableView()
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        newPostAlertController.addAction(postAction)
        newPostAlertController.addAction(cancelAction)
        
        self.present(newPostAlertController, animated: true, completion: nil)
    }
    
    func presentErrorAlert() {
        let errorAlertController = UIAlertController(title: "User is missing information", message: "Please try again", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        errorAlertController.addAction(okAction)
        self.present(errorAlertController, animated: true, completion: nil)
    }
    
    // MARK: - Table View Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PostController.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath)
        let post = PostController.posts[indexPath.row]
        let dateAsString = Date(timeIntervalSince1970: post.timestamp).asString
        cell.textLabel?.text = post.text
        cell.detailTextLabel?.text = "\(post.username) — \(dateAsString)"
        return cell
    }
    
    // MARK: - Actions
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        presentNewPostAlert()
    }
}
