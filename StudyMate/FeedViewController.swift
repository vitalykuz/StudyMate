//
//  FeedVC.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 8/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
	@IBOutlet var tableView: UITableView!
	static var imageCache: NSCache<NSString, UIImage> = NSCache()
	var posts = [Post]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.delegate = self
		tableView.dataSource = self

		startListeningToChangesInPost()
    }
	
	func startListeningToChangesInPost() {
		FeedManager.shared.startListeningToChangesInPost { (snapshot) in
			self.posts = []
			
			if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
				for snap in snapshot {
					if let postDict = snap.value as? Dictionary<String, Any> {
						let key = snap.key
						let post = Post(postId: key, postData: postDict)
						self.posts.append(post)
					}
				}
			}
			self.posts.reverse()
			self.tableView.reloadData()
		}
		
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let post = posts[indexPath.row]
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: POST_CELL) as? PostCell {
			//adds an action to the button in the cell
			cell.commentButtonOutlet.addTarget(self, action: #selector(FeedViewController.commentButtonTapped), for: .touchUpInside)
			if let profileImage = FeedViewController.imageCache.object(forKey: post.profileImageURL as NSString) {
				cell.configureCell(post: post, profileImage: profileImage)
			} else {
				cell.configureCell(post: post)
			}
			return cell
		} else {
			return PostCell()
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return posts.count
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
	
	@IBAction func signOutButtonTapped(_ sender: Any) {
		KeychainWrapper.standard.removeObject(forKey: Constants.DatabaseColumn.userID.rawValue)
		try! FIRAuth.auth()?.signOut()
		performSegue(withIdentifier: Constants.ViewController.signInViewController.rawValue, sender: nil)
	}

	@IBAction func accountButtonTapped(_ sender: Any) {
		performSegue(withIdentifier: Constants.ViewController.accountViewController.rawValue, sender: nil)
	}
	
	@IBAction func unwindToMain(segue:UIStoryboardSegue) { }
	
	func commentButtonTapped() {
		self.performSegue(withIdentifier: Constants.ViewController.commentViewController.rawValue, sender: self)
	}
}
