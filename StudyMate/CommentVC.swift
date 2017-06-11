//
//  CommentVC.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 4/6/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class CommentVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
	@IBOutlet var futureCommentLabel: TextFieldCustomView!
	@IBOutlet var tableView: UITableView!
	var postId: String = "empty"
	var commentId: String = "not provided"
	var testText: String = ":("
	var userName: String = "N/A"
	var profileImageUrl: String!
	var comments = [Comment]()
	var currentCommentRef: FIRDatabaseReference!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.delegate = self
		tableView.dataSource = self
		
		if KeychainWrapper.standard.string(forKey: "PostId") != nil {
			self.postId = KeychainWrapper.standard.string(forKey: "PostId")!
			//print("Vitaly: PostID is in key chain \(self.postId)")
		}
		
		
		
		findUser()
		
		startObservingChangesInComments()
		
    }
	
	func startObservingChangesInComments() {
		//DataService.ds.REF_COMMENTS.observe(.value, with: { (snapshot) in
		//DataService.ds.REF_POST_CURRENT.child(COMMENTS_LIST).observe(.value, with: { (snapshot) in
		DataService.ds.REF_POST_CURRENT.child("commentsList").observe(.value, with: { (snapshot) in
			//print("SNAPSHOT in ref comments : \(snapshot)")
			self.comments = []
			
			if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
				for snap in snapshot {
					print("SNAP in changes in comments : \(snap)")
					if let commentDict = snap.value as? Dictionary<String, AnyObject> {
						let key = snap.key
						let comment = Comment(commentId: key, commentData: commentDict)
						self.comments.append(comment)
					}
				}
			}
			self.comments.reverse()
			self.tableView.reloadData()
		})
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let comment = comments[indexPath.row]
		
		if let cell = tableView.dequeueReusableCell(withIdentifier: COMMENT_CELL) as? CommentCell {
			cell.configureCell(comment: comment)
			return cell
		} else {
			return PostCell()
		}
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return comments.count
	}
	
	@IBAction func backImageTapped(_ sender: Any) {
		self.performSegue(withIdentifier: "unwindToMain", sender: self)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

	@IBAction func sendButtonTapped(_ sender: Any) {
		guard let commentText = futureCommentLabel.text, commentText != "" else {
			futureCommentLabel.attributedPlaceholder = NSAttributedString(string: ERROR_COMMENT_TEXT_EMPTY, attributes: [NSForegroundColorAttributeName: UIColor.red])
			return
		}
		
		self.postToFirebase()
		
		currentCommentRef.observeSingleEvent(of: .value, with: { (snapshot) in
			if let _ = snapshot.value as? NSNull {
				//print("Vitaly: Current Comment Ref: \(String(describing: snapshot.value))")
				
				let comment: Dictionary<String, Any> = [
					USER_NAME: self.userName as Any,
					COMMENT_TEXT: self.futureCommentLabel.text as Any
				]
				
				//self.post.adjustLikes(addLike: true)
				self.currentCommentRef.setValue(comment)
			}
		})
		
	}
	
	func findUser() {
		let ref = DataService.ds.REF_BASE
		let userID = FIRAuth.auth()?.currentUser?.uid
		_ = ref.child(USERS).child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
			if let dictionary = snapshot.value as? [String: AnyObject] {
				//print("User: \(snapshot)")
				self.userName = (dictionary[USER_NAME] as? String)!
				//self.uni = dictionary[UNIVERSITY] as? String
				//self.profileImageUrl = dictionary[PROFILE_IMAGE_URL] as? String
			}
		})
	}
	
	func postToFirebase() {
		let comment: Dictionary<String, Any> = [
			//PROFILE_IMAGE_URL: self.profileImageUrl as Any,
			USER_NAME: self.userName as Any,
			COMMENT_TEXT: self.futureCommentLabel.text as Any
			//COMMENTS: 0 as Any,
			//LIKES: 0 as Any
		]
		
		let firebaseComment = DataService.ds.REF_COMMENTS.childByAutoId()
		//print("Comment id: \(firebaseComment.key)") // it works
		self.commentId = firebaseComment.key
		
		currentCommentRef  = DataService.ds.REF_POST_CURRENT.child(COMMENTS_LIST).child(self.commentId)
		//print("Vitaly: current comment ref \(currentCommentRef)")
		
		firebaseComment.setValue(comment)
	}
	
}
