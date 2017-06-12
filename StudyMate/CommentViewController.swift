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

class CommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
	@IBOutlet var futureCommentLabel: TextFieldCustomView!
	@IBOutlet var tableView: UITableView!
	var postId: String = "empty"
	var numberOfCommentsInt: Int = 0
	var commentId: String = "not provided"
	var testText: String = ":("
	var userName: String = "N/A"
	var profileImageUrl: String!
	var comments = [Comment]()
	var currentCommentRef: FIRDatabaseReference!
	var numberOfComments: FIRDatabaseReference!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		futureCommentLabel.delegate = self
		tableView.delegate = self
		tableView.dataSource = self
		
		if KeychainWrapper.standard.string(forKey: "PostId") != nil {
			self.postId = KeychainWrapper.standard.string(forKey: "PostId")!
			//print("Vitaly: PostID is in key chain \(self.postId)")
		}
		
		if KeychainWrapper.standard.string(forKey: "NumberOfComments") != nil {
			self.numberOfCommentsInt = Int(KeychainWrapper.standard.string(forKey: "NumberOfComments")!)!
		}
		
		findUser()
		
		startObservingChangesInComments()
		
    }
	
	func startObservingChangesInComments() {
		DataService.shared.REF_POST_CURRENT.child("commentsList").observe(.value, with: { (snapshot) in
			self.comments = []
			if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
				for snap in snapshot {
					//print("SNAP in changes in comments : \(snap)")
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
    }

	@IBAction func sendButtonTapped(_ sender: Any) {
		guard let commentText = futureCommentLabel.text, commentText != "" else {
			futureCommentLabel.attributedPlaceholder = NSAttributedString(string: ERROR_COMMENT_TEXT_EMPTY, attributes: [NSForegroundColorAttributeName: UIColor.red])
			return
		}
		
		self.postToFirebase()
		
		currentCommentRef.observeSingleEvent(of: .value, with: { (snapshot) in
			if let _ = snapshot.value as? NSNull {
				
				let comment: Dictionary<String, Any> = [
					Constants.DatabaseColumn.userName.rawValue: self.userName as Any,
					COMMENT_TEXT: self.futureCommentLabel.text as Any
				]

				self.currentCommentRef.setValue(comment)
				self.futureCommentLabel.text = ""
			}
		})
		_ = self.textFieldShouldReturn(futureCommentLabel)
		futureCommentLabel.attributedPlaceholder = NSAttributedString(string: "Type your comment here...", attributes: [NSForegroundColorAttributeName: UIColor.gray])
	}
	
	func findUser() {
		let ref = DataService.shared.REF_BASE
		let userID = FIRAuth.auth()?.currentUser?.uid
		_ = ref.child(Constants.DatabaseColumn.users.rawValue).child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
			if let dictionary = snapshot.value as? [String: AnyObject] {
				self.userName = (dictionary[Constants.DatabaseColumn.userName.rawValue] as? String)!
			}
		})
	}
	
	func postToFirebase() {
		let comment: Dictionary<String, Any> = [
			Constants.DatabaseColumn.userName.rawValue: self.userName as Any,
			COMMENT_TEXT: self.futureCommentLabel.text as Any
		]
		
		let firebaseComment = DataService.shared.REF_COMMENTS.childByAutoId()
		self.commentId = firebaseComment.key
		
		currentCommentRef  = DataService.shared.REF_POST_CURRENT.child(Constants.Posts.commentList.rawValue).child(self.commentId)
		
		// get access to number of comments stored as Ints in the database
		numberOfComments = DataService.shared.REF_POST_CURRENT.child("comments")
		numberOfComments.setValue(self.numberOfCommentsInt + 1)
		
		//new comment was added, so increment the number of comments
		self.numberOfCommentsInt = self.numberOfCommentsInt + 1
		KeychainWrapper.standard.set(self.numberOfCommentsInt, forKey: "NumberOfComments")
		
		firebaseComment.setValue(comment)
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
	
	// methods below resposible for moving text fields up, when the keyboard appears
	func textFieldDidBeginEditing(_ textField: UITextField) {
		animateViewMoving(up: true, moveValue: 250)
	}
	
	func textFieldDidEndEditing(_ textField: UITextField) {
		animateViewMoving(up: false, moveValue: 250)
	}
	
	func animateViewMoving (up:Bool, moveValue :CGFloat){
		let movementDuration:TimeInterval = 0.3
		let movement:CGFloat = ( up ? -moveValue : moveValue)
		UIView.beginAnimations( "animateView", context: nil)
		UIView.setAnimationBeginsFromCurrentState(true)
		UIView.setAnimationDuration(movementDuration )
		self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
		UIView.commitAnimations()
	}
	
}
