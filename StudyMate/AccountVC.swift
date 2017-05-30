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

class AccountVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	@IBOutlet var profileImage: UIImageView!
	@IBOutlet var nameLabel: TextFieldCustomView!
	@IBOutlet var uniLabel: TextFieldCustomView!
	@IBOutlet var profileDescription: UITextView!
	static var profileImageCache: NSCache<NSString, UIImage> = NSCache()
	var imagePicker: UIImagePickerController!
	var profileImageUrl: String = ""
	var imageSelected = false
	
    override func viewDidLoad() {
        super.viewDidLoad()

		imagePicker = UIImagePickerController()
		imagePicker.allowsEditing = true
		imagePicker.delegate = self
		
		self.fetchUserData()
    }
	
	
	//TO-DO you need to create a default profile image url, otherwice the app crashes
	func fetchUserData() {
			let ref = DataService.ds.REF_BASE
			let userID = FIRAuth.auth()?.currentUser?.uid
			_ = ref.child(USERS).child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
				if let dictionary = snapshot.value as? [String: AnyObject] {
					self.nameLabel.text = dictionary[USER_NAME] as? String
					self.profileDescription.text = dictionary[PROFILE_DESCRIPTION] as? String
					self.uniLabel.text = dictionary[UNIVERSITY] as? String
					self.profileImageUrl = dictionary[PROFILE_IMAGE_URL] as! String
					
					//TO-DO if a user is from facebook, set the imageSelected to true
					let provider  = dictionary[PROVIDER] as? String
					print("Provider: \(String(describing: provider))")
					if provider == PROVIDER_FACEBOOK {
						self.imageSelected = true
					}
					
					//checks if the image is in cache already
					if let profileImage = AccountVC.profileImageCache.object(forKey: self.profileImageUrl as NSString ) {
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
					print("Vitaly: Unable to download image from Firebase storage")
				} else {
					print("Vitaly: Image downloaded from Firebase storage")
					if let imgData = data {
						if let img = UIImage(data: imgData) {
							self.profileImage.image = img
							AccountVC.profileImageCache.setObject(img, forKey: self.profileImageUrl as NSString)
						}
					}
				}
			})
		}
	}
	
	// to-do it add a profile image each time the button is clicked
	@IBAction func saveButtonTapped(_ sender: Any) {
		guard let name = nameLabel.text, name != "" else {
			print("Vitaly: Name must be entered")
			return
		}
		
		guard let uni = uniLabel.text, uni != "" else {
			print("Vitaly: Uni must be entered")
			return
		}
		
		guard let profileDescription = profileDescription.text, profileDescription != "" else {
			print("Vitaly: Profile description must be provided")
			return
		}
		
		guard let profileImage = profileImage.image, imageSelected == true else {
			print("Vitaly: An image must be selected")
			return
		}
		
		if let imgData = UIImageJPEGRepresentation(profileImage, 0.2) {
			
			//gets a unique ID for the image
			let imgUid = NSUUID().uuidString
			let metadata = FIRStorageMetadata()
			metadata.contentType = "image/jpeg"
			
			DataService.ds.REF_PROFILE_IMAGES.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in
				if error != nil {
					print("Vitaly: Unable to upload image to Firebasee torage")
				} else {
					print("Vitaly: Successfully uploaded image to Firebase storage")
					let downloadURL = metadata?.downloadURL()?.absoluteString
					if let url = downloadURL {
						self.postToFirebase(imgUrl: url)
					}
				}
			}
		}
	}
	
	
	func postToFirebase(imgUrl: String) {
		let user: Dictionary<String, Any> = [
			USER_NAME: nameLabel.text! as Any,
			PROFILE_IMAGE_URL: imgUrl as Any,
			UNIVERSITY: uniLabel.text as Any,
			PROFILE_DESCRIPTION: profileDescription.text as Any
		]
		
		let currentUser  = DataService.ds.REF_USER_CURRENT
		print("Name \(currentUser.description())")
		currentUser.updateChildValues(user)
		//currentUser.setValuesForKeys(user)
		
//		let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
//		firebasePost.setValue(user)
	}

	
	@IBAction func backButtonTapped(_ sender: Any) {
		performSegue(withIdentifier: FEED_VC, sender: nil)
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
	
}
