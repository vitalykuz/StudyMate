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

class PostVC: UIViewController, UITextViewDelegate, UITextFieldDelegate {
	@IBOutlet var subjectNameField: TextFieldCustomView!
	@IBOutlet var locationField: TextFieldCustomView!
	@IBOutlet var whenLabel: TextFieldCustomView!
	@IBOutlet var postDescription: UITextView!
	
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	
//	var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
	
	private var userName: String?
	private var uni: String?
	private var profileImageUrl: String?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		postDescription.delegate = self
		subjectNameField.delegate = self
		whenLabel.delegate = self
		locationField.delegate = self
        // Do any additional setup after loading the view.
		
		postDescription.text = PROVIDE_POST_DESCRIPTION
		postDescription.textColor = UIColor.lightGray
		
		activityIndicator.isHidden = true
//		activityIndicator.center = self.view.center
//		activityIndicator.hidesWhenStopped = true
//		activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
//		view.addSubview(activityIndicator)
		
		
		self.findUser()
		
    }
	
	// TO-DO: when post is created, segue to feed vc
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
		
//		activityIndicator.stopAnimating()
//		activityIndicator.isHidden = true
//		UIApplication.shared.endIgnoringInteractionEvents()
		
		
	}
	
	func postToFirebase() {
		let post: Dictionary<String, Any> = [
			SUBJECT_NAME: self.subjectNameField.text as Any,
			LOCATION: self.locationField.text as Any,
			MEETING_TIME: self.whenLabel.text as Any,
			POST_DESCRIPTION: self.postDescription.text as Any,
			PROFILE_IMAGE_URL: self.profileImageUrl as Any,
			USER_NAME: self.userName as Any,
			UNIVERSITY: self.uni ?? ERROR_DEFAULT_VALUE,
			COMMENTS: 0 as Any,
			LIKES: 0 as Any
		]
		
		let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
		//print("Post id: \(firebasePost.key)") // it works
		firebasePost.setValue(post)
		
		self.updateActivityIndicator()
	}
	
	func updateActivityIndicator() {
		self.activityIndicator.stopAnimating()
		self.activityIndicator.isHidden = true
		UIApplication.shared.endIgnoringInteractionEvents()
		//self.performSegue(withIdentifier: "toFeedVC", sender: self)
	}

	func findUser() {
		let ref = DataService.ds.REF_BASE
		let userID = FIRAuth.auth()?.currentUser?.uid
		_ = ref.child(USERS).child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
			if let dictionary = snapshot.value as? [String: AnyObject] {
				self.userName = dictionary[USER_NAME] as? String
				self.uni = dictionary[UNIVERSITY] as? String
				self.profileImageUrl = dictionary[PROFILE_IMAGE_URL] as? String
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
	
	
}
