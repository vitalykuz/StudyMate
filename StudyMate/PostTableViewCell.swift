//
//  PostTableViewCell.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 9/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

	@IBOutlet var avatarImageView: UIImageView!
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

	func configureCell(post: Post) {
		self.post = post
		self.postDescriptionLabel.text = post.postDescription
		self.likesLabel.text = "\(post.likes)"
	}
	
}









