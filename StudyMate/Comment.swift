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
	private var _comment: String = "N/A"
	private var _commentId: String!
	private var _commentRef: FIRDatabaseReference!
	private var _userName: String!
	
	init(commentId: String, commentData: Dictionary<String, Any>) {
		self._commentId	= commentId
		
		if let commentText = commentData[COMMENT_TEXT] as? String {
			self._comment = commentText
		}
		
		if let userName = commentData[USER_NAME] as? String {
			self._userName = userName
		}
		
		_commentRef = DataService.ds.REF_COMMENTS.child(_commentId)
	}
	
	var commentId: String {
		return _commentId
	}
	
	var userName: String {
		return _userName
	}
	
	var comment: String {
		return _comment
	}
}

