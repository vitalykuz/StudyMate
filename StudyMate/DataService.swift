//
//  DataService.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 23/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//  Singleton

import Foundation
import Firebase
import SwiftKeychainWrapper

let DB_BASE = FIRDatabase.database().reference()
let STORAGE_BASE = FIRStorage.storage().reference()

class DataService {
	
	static let shared = DataService()
	
	// DB references
	private var _REF_BASE = DB_BASE
	private var _REF_POSTS = DB_BASE.child(Constants.Posts.posts.rawValue)
	private var _REF_USERS = DB_BASE.child(Constants.DatabaseColumn.users.rawValue)
	private var _REF_COMMENTS = DB_BASE.child(Constants.DatabaseColumn.commentsColumn.rawValue)
	
	// Storage references
	private var _REF_PROFILE_IMAGES = STORAGE_BASE.child(STORAGE_PROFILE_IMAGES)
	
	var REF_BASE: FIRDatabaseReference {
		return _REF_BASE
	}
	
	var REF_POSTS: FIRDatabaseReference {
		return _REF_POSTS
	}
	
	var REF_COMMENTS: FIRDatabaseReference {
		return _REF_COMMENTS
	}
	
	var REF_USERS: FIRDatabaseReference {
		return _REF_USERS
	}
	
	var REF_USER_CURRENT: FIRDatabaseReference {
		if let uid = KeychainWrapper.standard.string(forKey: Constants.DatabaseColumn.userID.rawValue) {
			let user = REF_USERS.child(uid)
			return user
		}
		return REF_USERS
	}
	
	var REF_POST_CURRENT: FIRDatabaseReference {
		if let postId =  KeychainWrapper.standard.string(forKey: "PostId") {
			let post = REF_POSTS.child(postId)
			return post
		}
		return REF_POSTS
	}
	
	var REF_PROFILE_IMAGES: FIRStorageReference {
		return _REF_PROFILE_IMAGES
	}
	
	func createFirbaseDBUser(uid: String, userData: Dictionary<String, Any>) {
		REF_USERS.child(uid).updateChildValues(userData)
	}
	
}
