//
//  CommentCell.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 4/6/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit
import QuartzCore

class CommentCell: UITableViewCell {
	@IBOutlet var profileImage: CustomCircleView!
	@IBOutlet var commentLabel: UILabel!
	var comment: Comment!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		
		commentLabel.layer.masksToBounds = true
		commentLabel.layer.cornerRadius = 15
		
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

	func configureCell(comment: Comment, profileImageURL: String) {
		self.comment = comment
		self.commentLabel.text = comment.comment
		
		
		let url = URL(string: comment.profileImageUrl)
		let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
		self.profileImage.image = UIImage(data: data!)
		
		//self.profileImage.image = comment.profileImageUrl
	
	}
}
