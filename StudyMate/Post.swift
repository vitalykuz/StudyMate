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
	private var _postKey: String!
	private var _postRef: FIRDatabaseReference!
	
	var caption: String {
		return _postDescription
	}
	
	var imageUrl: String {
		return _profileImageUrl
	}
	
	var likes: Int {
		return _likes
	}
	
	var postKey: String {
		return _postKey
	}
	
	init(postDescription: String, profileImageUrl: String, likes: Int) {
		self._postDescription = postDescription
		self._profileImageUrl = profileImageUrl
		self._likes = likes
	}
	
	init(postId: String, postData: Dictionary<String, AnyObject>) {
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
	
}
