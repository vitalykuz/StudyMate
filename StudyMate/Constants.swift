//
//  Constants.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 8/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit

//defines colors for shadows
let SHADOW_GRAY: CGFloat = 120.0 / 255.0

//database constants
let USER_ID = "uid"
let USER_EMAIL = "userEmail"
let PROVIDER = "provider"
let USER_NAME = "name"
let USERS = "users"
let COMMENTS_TABLE = "comments"
let PROFILE_IMAGE_URL = "profileImageURL"
let PROFILE_DESCRIPTION = "profileDescription"
let EMAIL_NOT_PROVIDED = "email not provided"

// Posts table in database
let POST_DESCRIPTION = "postDescription"
let POSTS = "posts"
let LIKES = "likes"
let COMMENTS = "comments"
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

// View Controllers
let ACCOUNT_VC = "toAccountVC"
let FEED_VC = "toFeedVC"

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






