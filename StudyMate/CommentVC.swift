//
//  CommentVC.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 4/6/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit
import Firebase

class CommentVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
	@IBOutlet var futureCommentLabel: TextFieldCustomView!
	@IBOutlet var tableView: UITableView!
	var comments = [Comment]()
	
    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.delegate = self
		tableView.dataSource = self
        // Do any additional setup after loading the view.
		
		startObservingChangesInComments()
		
    }
	
	func startObservingChangesInComments() {
		DataService.ds.REF_POSTS.observe(.value, with: { (snapshot) in
			
			self.comments = [] // THIS IS THE NEW LINE
			
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
			//self.tableView.reloadData()
		})

	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return CommentCell()
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 5
	}
	
	@IBAction func backImageTapped(_ sender: Any) {
		self.performSegue(withIdentifier: "unwindToMain", sender: self)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func sendButtonTapped(_ sender: Any) {
	}
}
