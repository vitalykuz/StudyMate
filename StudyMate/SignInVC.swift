//
//  ViewController.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 7/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase

class SignInVC: UIViewController {

	@IBOutlet var emailTextField: TextFieldCustomView!
	@IBOutlet var passwordTextField: TextFieldCustomView!
	
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}

	
	/* 
		@brief This methods tries to authenticate a user from Facebook.
		 If successful, than it sends the FB credentials to Firebase
	*/
	@IBAction func facebookButtonTapped(_ sender: Any) {
		
		let facebookLoginManager = FBSDKLoginManager()
		facebookLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
			if error != nil {
				print("Vitaly: unable to authenticate with facebook ")
			} else if result?.isCancelled == true {
				print("Vitaly: user cancelled FB auth ")
			} else {
				print("Vitaly: FB auth success ")
				let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
				self.firebaseAuth(credential)
			}
		}
	}

	/*
		@brief This methods tries to authenticate a user from Facebook to Firebase based on
		credentials obtained from Facebook
	*/
	func firebaseAuth(_ credential: FIRAuthCredential) {
		FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
			if error != nil {
				print("Vitaly: successful auth with Firebase ")
			} else {
				print("Vitaly: unable to auth with firebase ")
			}
		})
	}
	
	@IBAction func signInButtonTapped(_ sender: Any) {
		
		
		
		
	}
	
	
	
	
	
}








