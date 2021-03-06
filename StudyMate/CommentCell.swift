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
	@IBOutlet var nameLabel: UILabel!
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
    }

	func configureCell(comment: Comment) {
		self.comment = comment
		self.commentLabel.text = comment.comment
		self.nameLabel.text = "\(comment.userName) says:"
	}
}
