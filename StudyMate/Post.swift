//
//  Post.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 23/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import Foundation
import Firebase

class Post {
	private var _postDescription: String!
	private var _profileImageUrl: String!
	private var _likes: Int!
	private var _comments: Int!
	private var _location: String!
	private var _meetingTime: String!
	private var _userName: String!
	private var _subjectName: String!
	private var _uni: String!
	private var _postKey: String!
	private var _postRef: FIRDatabaseReference!
	
	init(postDescription: String, profileImageUrl: String, likes: Int) {
		self._postDescription = postDescription
		self._profileImageUrl = profileImageUrl
		self._likes = likes
	}
	
	init(postId: String, postData: Dictionary<String, Any>) {
		self._postKey = postId
		
		if let postDescription = postData[POST_DESCRIPTION] as? String {
			self._postDescription = postDescription
		}
		
		if let imageUrl = postData[PROFILE_IMAGE_URL] as? String {
			self._profileImageUrl = imageUrl
		}
		
		if let likes = postData[LIKES] as? Int {
			self._likes = likes
		}
		
		if let comments = postData[COMMENTS] as? Int {
			self._comments = comments
		}
		
		if let location = postData[LOCATION] as? String {
			self._location = location
		}
		
		if let meetingTime = postData[MEETING_TIME] as? String {
			self._meetingTime = meetingTime
		}
		
		if let userName = postData[USER_NAME] as? String {
			self._userName = userName
		}
		
		if let subjectName = postData[SUBJECT_NAME] as? String {
			self._subjectName = subjectName
		}
		
		if let uni = postData[UNIVERSITY] as? String {
			self._uni = uni
		}
		
		_postRef = DataService.ds.REF_POSTS.child(_postKey)
		
	}
	
	func adjustLikes(addLike: Bool) {
		if addLike {
			_likes = _likes + 1
		} else {
			_likes = likes - 1
		}
		_postRef.child(LIKES).setValue(_likes)
		
	}
	
	var postDescription: String {
		return _postDescription
	}
	
	var subjectName: String {
		return _subjectName
	}
	
	var uni: String {
		return _uni
	}
	
	var userName: String {
		return _userName
	}
	
	var meetingTime: String {
		return _meetingTime
	}
	
	var location: String {
		return _location
	}
	
	var comments: Int {
		return _comments
	}
	
	var profileImageURL: String {
		return _profileImageUrl
	}
	
	var likes: Int {
		return _likes
	}
	
	var postKey: String {
		return _postKey
	}
}
