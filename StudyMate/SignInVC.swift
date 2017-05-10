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
import SwiftKeychainWrapper

class SignInVC: UIViewController, UITextFieldDelegate {

	@IBOutlet var emailTextField: TextFieldCustomView!
	@IBOutlet var passwordTextField: TextFieldCustomView!
	var activeField: UITextField?
	@IBOutlet var scrollView: UIScrollView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		emailTextField.delegate = self
		passwordTextField.delegate = self
	}
	
	override func viewDidAppear(_ animated: Bool) {
		//checks if i got the uid in key chain
		if KeychainWrapper.standard.string(forKey: KEY_UID) != nil {
			print("Vitaly: User ID is in key chain")
			performSegue(withIdentifier: "toFeedVC", sender: nil)
		}
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
				print("Vitaly: unable to auth with firebase error: \(error.debugDescription) ")
			} else {
				print("Vitaly: successful auth with Firebase ")
				if let user = user {
					self.saveUserIdToKeyChain(id: user.uid)
				}
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
					if let user = user {
						self.saveUserIdToKeyChain(id: user.uid)
					}
				} else {
					FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error ) in
						if ( error != nil ) {
							print("Vitaly: unable to auth with email firebase")
						} else {
							print("Vitaly: new user with email created with Firebase")
							if let user = user {
								self.saveUserIdToKeyChain(id: user.uid)
							}
						}
					})
				}
			})
		}
	}
	
	func saveUserIdToKeyChain(id: String) {
		KeychainWrapper.standard.set(id, forKey: KEY_UID)
		performSegue(withIdentifier: "toFeedVC", sender: nil)
	}
	
	
	// methods below resposible for moving text fields up, when the keyboard appears
	func textFieldDidBeginEditing(_ textField: UITextField) {
		animateViewMoving(up: true, moveValue: 100)
	}
	func textFieldDidEndEditing(_ textField: UITextField) {
		animateViewMoving(up: false, moveValue: 100)
	}
	
	func animateViewMoving (up:Bool, moveValue :CGFloat){
		let movementDuration:TimeInterval = 0.3
		let movement:CGFloat = ( up ? -moveValue : moveValue)
		UIView.beginAnimations( "animateView", context: nil)
		UIView.setAnimationBeginsFromCurrentState(true)
		UIView.setAnimationDuration(movementDuration )
		self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
		UIView.commitAnimations()
	}
	
}








