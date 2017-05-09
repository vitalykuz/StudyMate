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
		
		//defines the parameters for shadows
		layer.shadowColor = UIColor(displayP3Red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 1.0).cgColor
		layer.shadowOpacity = 1.0
		layer.shadowRadius = 5.0
		layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()		
		layer.cornerRadius = self.frame.width / 2
	}
}
