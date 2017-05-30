//
//  PostCell.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 9/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit
import Firebase

class PostCell: UITableViewCell {

	@IBOutlet var profileImage: UIImageView!
	@IBOutlet var nameLabel: UILabel!
	@IBOutlet var uniLabel: UILabel!
	@IBOutlet var subjectNameLabel: UILabel!
	@IBOutlet var postDescriptionLabel: UILabel!
	@IBOutlet var locationLabel: UILabel!
	@IBOutlet var timeLabel: UILabel!
	@IBOutlet var likesLabel: UILabel!
	
	var post: Post!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func configureCell(post: Post, profileImage: UIImage? = nil) {
		self.post = post
		self.postDescriptionLabel.text = post.postDescription
		self.likesLabel.text = "\(post.likes)"
		
		if profileImage != nil {
			self.profileImage.image = profileImage
		} else {
			let ref = FIRStorage.storage().reference(forURL: post.profileImageURL)
			ref.data(withMaxSize: 2 * 1024 * 1024, completion: { (data, error) in
				if error != nil {
					print("Vitaly: Unable to download image from Firebase storage")
				} else {
					print("Vitaly: Image downloaded from Firebase storage")
					if let imgData = data {
						if let profileImage = UIImage(data: imgData) {
							self.profileImage.image = profileImage
							FeedVC.imageCache.setObject(profileImage, forKey: post.profileImageURL as NSString)
						}
					}
				}
			})
		}
		
	}
	
}









