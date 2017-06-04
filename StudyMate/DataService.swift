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
	
	static let ds = DataService()

	// DB references
	private var _REF_BASE = DB_BASE
	private var _REF_POSTS = DB_BASE.child(POSTS)
	private var _REF_USERS = DB_BASE.child(USERS)
	private var _REF_COMMENTS = DB_BASE.child(COMMENTS_TABLE)
	
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
		//let uid = KeychainWrapper.stringForKey(KEY_UID)
		//let uid = KeychainWrapper.set(KEY_UID)
		//let uid = KeychainWrapper.defaultKeychainWrapper.string(forKey: KEY_UID)
		let uid = KeychainWrapper.standard.string(forKey: USER_ID)
		let user = REF_USERS.child(uid!)
		return user
	}
	
	var REF_PROFILE_IMAGES: FIRStorageReference {
		return _REF_PROFILE_IMAGES
	}
	
	func createFirbaseDBUser(uid: String, userData: Dictionary<String, Any>) {
		REF_USERS.child(uid).updateChildValues(userData)
	}
	
}
