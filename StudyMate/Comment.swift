//
//  Comment.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 4/6/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import Foundation
import Firebase

class Comment {
	private var _profileImageUrl: String!
	private var _comment: String!
	
	var profileImageUrl: String {
		return _profileImageUrl
	}
	
	var comment: String {
		return _comment
	}
}

