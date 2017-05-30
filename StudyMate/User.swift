//
//  User.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 29/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import Foundation

class User {
	private var _postDescription: String!
	private var _profileImageUrl: String!
	private var _likes: Int!
	private var _postKey: String!
	
	
	var postDescription: String {
		return _postDescription
	}
	
	var profileImageURL: String {
		return _profileImageUrl
	}
	
}
