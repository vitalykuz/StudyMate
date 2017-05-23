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

class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
	@IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.delegate = self
		tableView.dataSource = self
        // Do any additional setup after loading the view.
		
		//listens to any changes made to posts table in Firebase database
		startListeningToChangesInPost()
    }
	
	func startListeningToChangesInPost() {
		DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
			
			//self.posts = [] // THIS IS THE NEW LINE
			
			if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
				for snap in snapshot {
					print("SNAP: \(snap)")
//					if let postDict = snap.value as? Dictionary<String, AnyObject> {
//						let key = snap.key
//						let post = Post(postKey: key, postData: postDict)
//						self.posts.append(post)
//					}
				}
			}
			self.tableView.reloadData()
		})
	}

	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostTableViewCell
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 3
	}
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func signOutButtonTapped(_ sender: Any) {
		KeychainWrapper.standard.removeObject(forKey: USER_ID)
		try! FIRAuth.auth()?.signOut()
		performSegue(withIdentifier: "toSignInVC", sender: nil)
	}

}
