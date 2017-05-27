//
//  AccountVC.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 25/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit

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
    }
	
	@IBAction func saveButtonTapped(_ sender: Any) {
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
