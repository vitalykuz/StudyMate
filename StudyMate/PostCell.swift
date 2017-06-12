//
//  PostCell.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 9/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class PostCell: UITableViewCell {

	@IBOutlet var profileImage: UIImageView!
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var uniLabel: UILabel!
	@IBOutlet var subjectNameLabel: UILabel!
	@IBOutlet var postDescriptionLabel: UILabel!
	@IBOutlet var locationLabel: UILabel!
	@IBOutlet var timeLabel: UILabel!
	@IBOutlet var likesLabel: UILabel!
	@IBOutlet var likeImage: UIImageView!
	@IBOutlet var commentsLabel: UILabel!
	@IBOutlet var commentButtonOutlet: UIButton!
	@IBOutlet var userDetailsOutlet: UIButton!
	
	var post: Post!
	var likesRef: FIRDatabaseReference!
	
    override func awakeFromNib() {
        super.awakeFromNib()

		let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
		tap.numberOfTapsRequired = 1
		likeImage.addGestureRecognizer(tap)
		likeImage.isUserInteractionEnabled = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	func configureCell(post: Post, profileImage: UIImage? = nil) {
		self.post = post
		likesRef  = DataService.shared.REF_USER_CURRENT.child(Constants.Posts.likes.rawValue).child(post.postKey)
		
		self.postDescriptionLabel.text = post.postDescription
		self.likesLabel.text = "\(post.likes)"
		self.commentsLabel.text = "\(post.comments)"
		self.locationLabel.text = post.location
		self.timeLabel.text = post.meetingTime
		self.nameLabel.text = post.userName
		self.uniLabel.text = post.uni
		self.subjectNameLabel.text = post.subjectName

		
		if profileImage != nil {
			self.profileImage.image = profileImage
		} else {
			let ref = FIRStorage.storage().reference(forURL: post.profileImageURL)
			ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
				if error != nil {
				} else {
					if let imgData = data {
						if let profileImage = UIImage(data: imgData) {
							self.profileImage.image = profileImage
							FeedViewController.imageCache.setObject(profileImage, forKey: post.profileImageURL as NSString)
						}
					}
				}
			})
		}
		
		likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
			if let _ = snapshot.value as? NSNull {
				self.likeImage.image = UIImage(named: INITIAL_HEART)
			} else {
				self.likeImage.image = UIImage(named: LIKED_HEART)
			}
		})
		
	}

	func likeTapped(sender: UITapGestureRecognizer) {
		likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
			if let _ = snapshot.value as? NSNull {
				self.likeImage.image = UIImage(named: INITIAL_HEART)
				self.post.adjustLikes(addLike: true)
				self.likesRef.setValue(true)
			} else {
				self.likeImage.image = UIImage(named: LIKED_HEART)
				self.post.adjustLikes(addLike: false)
				self.likesRef.removeValue()
			}
		})
	}
	
	@IBAction func commentButtonTapped(_ sender: Any) {
		KeychainWrapper.standard.set(self.post.postKey, forKey: "PostId")
		KeychainWrapper.standard.set(self.commentsLabel.text!, forKey: "NumberOfComments")
		
	}

	@IBAction func userDetailsTapped(_ sender: Any) {
	}
}









