//
//  AccountVC.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 25/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit
import Firebase

class AccountVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	@IBOutlet var profileImage: UIImageView!
	@IBOutlet var nameLabel: TextFieldCustomView!
	@IBOutlet var uniLabel: TextFieldCustomView!
	@IBOutlet var profileDescription: UITextView!
	static var profileImageCache: NSCache<NSString, UIImage> = NSCache()
	var imagePicker: UIImagePickerController!
	var profileImageUrl: String = ""
	
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
					print("Profile image url: \(dictionary[PROFILE_IMAGE_URL])")
					self.profileImageUrl = dictionary[PROFILE_IMAGE_URL] as! String
					print("Profile image url: \(self.profileImageUrl)")

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
	
	@IBAction func saveButtonTapped(_ sender: Any) {
		if (self.nameLabel.text?.isEmpty)! {
			
		}
	}
	
	@IBAction func backButtonTapped(_ sender: Any) {
		performSegue(withIdentifier: FEED_VC, sender: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		if let image  = info[UIImagePickerControllerEditedImage] as? UIImage {
			profileImage.image = image
		} else {
			print("Vitaly: not valid image")
		}
		imagePicker.dismiss(animated: true, completion: nil)
	}
	
	@IBAction func profileImageTapped(_ sender: Any) {
		present(imagePicker, animated: true, completion: nil)
	}
	
}
