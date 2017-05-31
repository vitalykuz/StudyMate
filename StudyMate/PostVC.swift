//
//  PostVC.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 31/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit

class PostVC: UIViewController {
	@IBOutlet var subjectNameField: TextFieldCustomView!
	@IBOutlet var locationField: TextFieldCustomView!
	@IBOutlet var whenLabel: TextFieldCustomView!
	@IBOutlet var postDescription: UITextView!
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
		
//		guard let description = postDescription.text, description != "" else {
//			postDescription.attributedPlaceholder = NSAttributedString(string: ERROR_POST_DESCRIPTION_EMPTY, attributes: [NSForegroundColorAttributeName: UIColor.red])
//			return
//		}
		
//		if let imgData = UIImageJPEGRepresentation(img, 0.2) {
//			
//			let imgUid = NSUUID().uuidString
//			let metadata = FIRStorageMetadata()
//			metadata.contentType = "image/jpeg"
//			
//			DataService.ds.REF_POST_IMAGES.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in
//				if error != nil {
//					print("JESS: Unable to upload image to Firebasee torage")
//				} else {
//					print("JESS: Successfully uploaded image to Firebase storage")
//					let downloadURL = metadata?.downloadURL()?.absoluteString
//					if let url = downloadURL {
//						self.postToFirebase(imgUrl: url)
//					}
//				}
//			}
//		}
	}
	
//	func postToFirebase(imgUrl: String) {
//		let post: Dictionary<String, AnyObject> = [
//			"caption": captionField.text! as AnyObject,
//			"imageUrl": imgUrl as AnyObject,
//			"likes": 0 as AnyObject
//		]
//		
//		let firebasePost = DataService.ds.REF_POSTS.childByAutoId()
//		firebasePost.setValue(post)
//		
//		captionField.text = ""
//		imageSelected = false
//		imageAdd.image = UIImage(named: "add-image")
//		
//		tableView.reloadData()
//	}


}
