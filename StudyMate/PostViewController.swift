//
//  PostVC.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 31/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class PostViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
	@IBOutlet var subjectNameField: TextFieldCustomView!
	@IBOutlet var locationField: TextFieldCustomView!
	@IBOutlet var whenLabel: TextFieldCustomView!
	@IBOutlet var postDescription: UITextView!
	
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	
	private var userName: String?
	private var uni: String?
	private var profileImageUrl: String?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		postDescription.delegate = self
		subjectNameField.delegate = self
		whenLabel.delegate = self
		locationField.delegate = self
		
		postDescription.text = PROVIDE_POST_DESCRIPTION
		postDescription.textColor = UIColor.lightGray
		
		activityIndicator.isHidden = true

		NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(PostViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		
		self.findUser()
		
    }

	@IBAction func createPostButtonTapped(_ sender: Any) {
		guard let subjectName = subjectNameField.text, subjectName != "" else {
			subjectNameField.attributedPlaceholder = NSAttributedString(string: ERROR_SUBJECT_NAME_EMPTY, attributes: [NSForegroundColorAttributeName: UIColor.red])
			return
		}
		
		guard let location = locationField.text, location != "" else {
			locationField.attributedPlaceholder = NSAttributedString(string: ERROR_LOCATION_EMPTY, attributes: [NSForegroundColorAttributeName: UIColor.red])
			return
		}

		guard let time = whenLabel.text, time != "" else {
			whenLabel.attributedPlaceholder = NSAttributedString(string: ERROR_MEETING_TIME_EMPTY, attributes: [NSForegroundColorAttributeName: UIColor.red])
			return
		}
		
		guard let description = postDescription.text, description != "" else {
			postDescription.text = ERROR_POST_DESCRIPTION_EMPTY
			postDescription.textColor = UIColor.red
			return
		}
		
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
		UIApplication.shared.beginIgnoringInteractionEvents()
		
		self.postToFirebase()
	}
	
	func postToFirebase() {
		let post: Dictionary<String, Any> = [
			SUBJECT_NAME: self.subjectNameField.text as Any,
			LOCATION: self.locationField.text as Any,
			MEETING_TIME: self.whenLabel.text as Any,
			Constants.Posts.postDescription.rawValue: self.postDescription.text as Any,
			Constants.DatabaseColumn.profileImageUrl.rawValue: self.profileImageUrl as Any,
			Constants.DatabaseColumn.userName.rawValue: self.userName as Any,
			UNIVERSITY: self.uni ?? ERROR_DEFAULT_VALUE,
			Constants.Posts.comments.rawValue: 0 as Any,
			Constants.Posts.likes.rawValue: 0 as Any
		]
		
		let firebasePost = DataService.shared.REF_POSTS.childByAutoId()
		firebasePost.setValue(post)
		
		self.updateActivityIndicator()
	}
	
	func updateActivityIndicator() {
		self.activityIndicator.stopAnimating()
		self.activityIndicator.isHidden = true
		UIApplication.shared.endIgnoringInteractionEvents()
	}

	func findUser() {
		let ref = DataService.shared.REF_BASE
		let userID = FIRAuth.auth()?.currentUser?.uid
		_ = ref.child(Constants.DatabaseColumn.users.rawValue).child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
			if let dictionary = snapshot.value as? [String: AnyObject] {
				self.userName = dictionary[Constants.DatabaseColumn.userName.rawValue] as? String
				self.uni = dictionary[UNIVERSITY] as? String
				self.profileImageUrl = dictionary[Constants.DatabaseColumn.profileImageUrl.rawValue] as? String
			}
		})
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
	
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		if(text == "\n") {
			textView.resignFirstResponder()
			return false
		}
		return true
	}
	
	func textViewDidBeginEditing(_ textView: UITextView) {
		if textView.textColor == UIColor.lightGray || textView.textColor == UIColor.red {
			textView.text = nil
			textView.textColor = UIColor.black
		}
	}
	
	func textViewDidEndEditing(_ textView: UITextView) {
		if textView.text.isEmpty {
			textView.text = PROVIDE_POST_DESCRIPTION
			textView.textColor = UIColor.lightGray
		}
	}
	
	func keyboardWillShow(notification: NSNotification) {
		self.view.frame.origin.y -= 50
	}
	
	func keyboardWillHide(notification: NSNotification) {
		self.view.frame.origin.y += 50
	}
}
