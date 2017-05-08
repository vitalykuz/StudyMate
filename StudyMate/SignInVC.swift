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

class SignInVC: UIViewController, UITextFieldDelegate {

	@IBOutlet var emailTextField: TextFieldCustomView!
	@IBOutlet var passwordTextField: TextFieldCustomView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		emailTextField.delegate = self
		passwordTextField.delegate = self
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
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
	
	
	/*
	@brief This methods tries to sign in a Firebase user with email. 
	 If the user does not exist (does not have an acc), it creates a new user with provided email and password.
	*/
	@IBAction func signInButtonTapped(_ sender: Any) {
		//checks if text fields are not empty
		if let email = emailTextField.text, let password = passwordTextField.text {
			FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
				if ( error == nil ) {
					print("Vitaly: success login with email Firebase")
				} else {
					FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error ) in
						if ( error != nil ) {
							print("Vitaly: unable to auth with email firebase")
						} else {
							print("Vitaly: new user with email created with Firebase")
						}
					})
				}
			})
		}
	}
}








