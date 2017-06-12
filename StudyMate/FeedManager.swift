//
//  FeedManager.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 26/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import Foundation
import Firebase

class FeedManager {
	
	static let shared = FeedManager()
	
	// func to observe changes in post
	func startListeningToChangesInPost(completion: @escaping (FIRDataSnapshot) -> Swift.Void ) -> Void {
		DataService.shared.REF_POSTS.observe(.value, with: completion)
	}
}
