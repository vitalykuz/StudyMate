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

	func configureCell(comment: Comment) {
		self.comment = comment
		self.commentLabel.text = comment.comment
	}
	
}
