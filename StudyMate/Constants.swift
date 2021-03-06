//
//  Constants.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 8/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit

enum Constants: String {
	
	enum DatabaseColumn: String {
		case userID = "uid"
		case userEmail = "userEmail"
		case provider = "provider"
		case userName = "name"
		case users = "users"
		case commentsColumn = "comments"
		case profileImageUrl = "profileImageURL"
		case profileDescription = "profileDescription"
	}
	
	enum Posts: String {
		case postDescription = "postDescription"
		case posts = "posts"
		case likes = "likes"
		case comments = "comments"
		case commentList = "commentsList"
	}
	
	enum ViewController: String {
		case feedViewController = "toFeedVC"
		case accountViewController = "toAccountVC"
		case signInViewController = "toSignInVC"
		case commentViewController = "toCommentVC"
	}
	
	case error = "error"
}

//defines colors for shadows
let SHADOW_GRAY: CGFloat = 120.0 / 255.0

let EMAIL_NOT_PROVIDED = "email not provided"

let UNIVERSITY = "uni"
let SUBJECT_NAME = "subjectName"
let LOCATION = "location"
let MEETING_TIME = "meetingTime"

//Comments table in database
let COMMENT_TEXT = "commentText"
let COMMENT_IMAGE = "profileImageURL"

// identifiers
let POST_CELL = "postCell"
let COMMENT_CELL = "CommentCell"

// Images
let DEFAULT_PROFILE_IMAGE_URL = "https://firebasestorage.googleapis.com/v0/b/study-mate-86d3d.appspot.com/o/profile-images%2Fprofile_image.png?alt=media&token=e27fec66-cfba-4740-ab3b-3801a9c2ed9d"
let INITIAL_HEART = "initial-heart"
let LIKED_HEART = "liked-heart"

//providers
let PROVIDER_FACEBOOK = "facebook.com"

// Error messages
let ERROR_SUBJECT_NAME_EMPTY = "Subject name is required"
let ERROR_LOCATION_EMPTY = "Meeting location is required"
let ERROR_MEETING_TIME_EMPTY = "Meeting time is required"
let ERROR_POST_DESCRIPTION_EMPTY = "Plese provide post description"
let ERROR_DEFAULT_VALUE = "Default value"
let ERROR_COMMENT_TEXT_EMPTY = "Cannot be empty"

// placeholders
let PROVIDE_POST_DESCRIPTION = "Add post description"

//data in Firebase Storage
let STORAGE_PROFILE_IMAGES = "profile-images"






