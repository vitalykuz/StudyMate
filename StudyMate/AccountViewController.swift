//
//  AccountVC.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 25/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class AccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
	@IBOutlet var profileImage: UIImageView!
	@IBOutlet var nameLabel: TextFieldCustomView!
	@IBOutlet var uniLabel: TextFieldCustomView!
	@IBOutlet var profileDescription: UITextView!
	static var profileImageCache: NSCache<NSString, UIImage> = NSCache()
	
	//TO-DO: make it private
	var imagePicker: UIImagePickerController!
	var profileImageUrl: String = ""
	var imageSelected = false
	
    override func viewDidLoad() {
        super.viewDidLoad()

		imagePicker = UIImagePickerController()
		imagePicker.allowsEditing = true
		imagePicker.delegate = self
		
		nameLabel.delegate = self
		uniLabel.delegate = self
		profileDescription.delegate = self
		
		NotificationCenter.default.addObserver(self, selector: #selector(AccountViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(AccountViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
		
		self.fetchUserData()
    }
	
	func fetchUserData() {
			let ref = DataService.shared.REF_BASE
			let userID = FIRAuth.auth()?.currentUser?.uid
			_ = ref.child(Constants.DatabaseColumn.users.rawValue).child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
				if let dictionary = snapshot.value as? [String: AnyObject] {
					self.nameLabel.text = dictionary[Constants.DatabaseColumn.userName.rawValue] as? String
					self.profileDescription.text = dictionary[Constants.DatabaseColumn.profileDescription.rawValue] as? String
					self.uniLabel.text = dictionary[UNIVERSITY] as? String
					self.profileImageUrl = dictionary[Constants.DatabaseColumn.profileImageUrl.rawValue] as! String

					let provider  = dictionary[Constants.DatabaseColumn.provider.rawValue] as? String
					if provider == PROVIDER_FACEBOOK {
						self.imageSelected = true
					}
					
					//checks if the image is in cache already
					if let profileImage = AccountViewController.profileImageCache.object(forKey: self.profileImageUrl as NSString ) {
							self.checkProfileImage(profileImage: profileImage)
					} else {
						self.checkProfileImage()
					}
				}
			})
	}
	
	func checkProfileImage(profileImage: UIImage? = nil) {
		if profileImage != nil {
			self.profileImage.image = profileImage
		} else {
			let ref = FIRStorage.storage().reference(forURL: self.profileImageUrl)
			ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
				if error != nil {
				} else {
					if let imgData = data {
						if let img = UIImage(data: imgData) {
							self.profileImage.image = img
							AccountViewController.profileImageCache.setObject(img, forKey: self.profileImageUrl as NSString)
						}
					}
				}
			})
		}
	}
	
	// to-do it adds a profile image each time the button is clicked
	// when saved is cliked segue to another controller
	@IBAction func saveButtonTapped(_ sender: Any) {
		guard let name = nameLabel.text, name != "" else {
			return
		}
		
		guard let uni = uniLabel.text, uni != "" else {
			return
		}
		
		guard let profileDescription = profileDescription.text, profileDescription != "" else {
			return
		}
		
		guard let profileImage = profileImage.image, imageSelected == true else {
			return
		}
		
		if let imgData = UIImageJPEGRepresentation(profileImage, 1) {
			
			//gets a unique ID for the image
			let imgUid = NSUUID().uuidString
			let metadata = FIRStorageMetadata()
			metadata.contentType = "image/jpeg"
			
			DataService.shared.REF_PROFILE_IMAGES.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in
				if error != nil {
				} else {
					let downloadURL = metadata?.downloadURL()?.absoluteString
					if let url = downloadURL {
						self.postToFirebase(imgUrl: url)
					}
				}
			}
		}
		self.imageSelected = true
	}
	
	
	func postToFirebase(imgUrl: String) {
		let user: Dictionary<String, Any> = [
			Constants.DatabaseColumn.userName.rawValue: nameLabel.text! as Any,
			Constants.DatabaseColumn.profileImageUrl.rawValue: imgUrl as Any,
			UNIVERSITY: uniLabel.text as Any,
			Constants.DatabaseColumn.profileDescription.rawValue: profileDescription.text as Any
		]
		
		let currentUser  = DataService.shared.REF_USER_CURRENT
		currentUser.updateChildValues(user)
	}

	
	@IBAction func backButtonTapped(_ sender: Any) {
		performSegue(withIdentifier: Constants.ViewController.feedViewController.rawValue, sender: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image  = info[UIImagePickerControllerEditedImage] as? UIImage {
			profileImage.image = image
			self.imageSelected = true
		} else {
			print("Vitaly: not valid image")
		}
		imagePicker.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func profileImageTapped(_ sender: Any) {
		present(imagePicker, animated: true, completion: nil)
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

	func keyboardWillShow(notification: NSNotification) {
		 self.view.frame.origin.y -= 150
	}
	
	func keyboardWillHide(notification: NSNotification) {
		 self.view.frame.origin.y += 150
	}
}
