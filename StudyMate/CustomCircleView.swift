//
//  CustomCircleView.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 9/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit

class CustomCircleView: UIImageView {

	override func awakeFromNib() {
		super.awakeFromNib()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()		
		layer.cornerRadius = self.frame.width / 2
		clipsToBounds = true
	}
}
