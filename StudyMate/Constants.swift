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

// identifiers
let POST_CELL = "postCell"

// View Controllers
let ACCOUNT_VC = "toAccountVC"
let FEED_VC = "toFeedVC"

// Profile Images 
let DEFAULT_PROFILE_IMAGE_URL = "https://firebasestorage.googleapis.com/v0/b/study-mate-86d3d.appspot.com/o/profile-images%2Fprofile_image.png?alt=media&token=e27fec66-cfba-4740-ab3b-3801a9c2ed9d"

//providers
let PROVIDER_FACEBOOK = "facebook.com"

// Error messages
let ERROR_SUBJECT_NAME_EMPTY = "Subject name is required"
let ERROR_LOCATION_EMPTY = "Meeting location is required"
let ERROR_MEETING_TIME_EMPTY = "Meeting time is required"
let ERROR_POST_DESCRIPTION_EMPTY = "Plese provide post description"
let ERROR_DEFAULT_VALUE = "Default value"

// placeholders
let PROVIDE_POST_DESCRIPTION = "Add post description"
