//
//  TextFieldCustomView.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 8/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit

class TextFieldCustomView: UITextField {

	override func awakeFromNib() {
		super.awakeFromNib()
		
		layer.borderColor = UIColor(displayP3Red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: 0.3).cgColor
		layer.borderWidth = 1.0
		layer.cornerRadius = 2.0
	}
	
	override func textRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: 10, dy: 5)
	}
	
	override func editingRect(forBounds bounds: CGRect) -> CGRect {
		return bounds.insetBy(dx: 10, dy: 5)
	}
}
