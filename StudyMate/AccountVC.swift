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
	
	var imagePicker: UIImagePickerController!
	
    override func viewDidLoad() {
        super.viewDidLoad()

		imagePicker = UIImagePickerController()
		imagePicker.allowsEditing = true
		imagePicker.delegate = self
		
		self.fetchUserData()
    }
	
	func fetchUserData() {
			let ref = DataService.ds.REF_BASE
			let userID = FIRAuth.auth()?.currentUser?.uid
			_ = ref.child(USERS).child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
				if let dictionary = snapshot.value as? [String: AnyObject] {
						self.nameLabel.text = dictionary[USER_NAME] as? String
						self.profileDescription.text = dictionary[PROFILE_DESCRIPTION] as? String
						self.uniLabel.text = dictionary[UNIVERSITY] as? String
						let userProvider = dictionary[PROVIDER] as? String
						//user came from Facebook, so we have name, profile image url
						if userProvider == "facebook.com" {
							self.nameLabel.text = dictionary[USER_NAME] as? String
							//self.profileImage.image = dictionary[PROFILE_IMAGE_URL] as? UIImage
						}
					}
			})
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
