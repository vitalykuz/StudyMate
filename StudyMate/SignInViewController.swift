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

class SignInViewController: UIViewController, UITextFieldDelegate {
	@IBOutlet var activityIndicator: UIActivityIndicatorView!
	@IBOutlet var emailTextField: TextFieldCustomView!
	@IBOutlet var passwordTextField: TextFieldCustomView!
	var activeField: UITextField?
	@IBOutlet var scrollView: UIScrollView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		emailTextField.delegate = self
		passwordTextField.delegate = self
		
		activityIndicator.isHidden = true
	}
	
	override func viewDidAppear(_ animated: Bool) {
		//checks if i got the uid in key chain
		if KeychainWrapper.standard.string(forKey: Constants.DatabaseColumn.userID.rawValue) != nil {
			performSegue(withIdentifier: Constants.ViewController.feedViewController.rawValue, sender: nil)
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
		self.startAcivityIndicator()
		
		let facebookLoginManager = FBSDKLoginManager()
		facebookLoginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
			if error != nil {
				self.updateActivityIndicator()
			} else if result?.isCancelled == true {
				self.updateActivityIndicator()
			} else {
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
				self.updateActivityIndicator()
			} else {
				if let user = user {
					self.saveFBProfileImageToFirebase(profileImageUrl: user.photoURL!)
					
					let userData = [Constants.DatabaseColumn.userEmail.rawValue: user.email!, Constants.DatabaseColumn.provider.rawValue: credential.provider, Constants.DatabaseColumn.userName.rawValue: user.displayName!] as [String : Any]
					self.saveUserDataToKeyChain(userId: user.uid, userData: userData)
					self.updateActivityIndicator()
				}
			}
		})
	}
	
	func saveFBProfileImageToFirebase(profileImageUrl: URL){
		let data = try? Data(contentsOf: profileImageUrl)
		let profileImage = UIImage(data: data!)
		
		if let imgData = UIImageJPEGRepresentation(profileImage!, 1) {
			
			//gets a unique ID for the image
			let imgUid = NSUUID().uuidString
			let metadata = FIRStorageMetadata()
			metadata.contentType = "image/jpeg"
			
			DataService.shared.REF_PROFILE_IMAGES.child(imgUid).put(imgData, metadata: metadata) { (metadata, error) in
				if error != nil {
				} else {
					let downloadURL = metadata?.downloadURL()?.absoluteString
					if let url = downloadURL {
						self.updateDatabase(imgUrl: url)
					}
				}
			}
		}
	}
	
	func updateDatabase(imgUrl: String) {
		let user: Dictionary<String, Any> = [
			Constants.DatabaseColumn.profileImageUrl.rawValue: imgUrl as Any,
		]
		
		let currentUser  = DataService.shared.REF_USER_CURRENT
		currentUser.updateChildValues(user)
	}
	
	/*
	@brief This methods tries to sign in a Firebase user with email.
	 If the user does not exist (does not have an acc), it creates a new user with provided email and password.
	*/
	@IBAction func signInButtonTapped(_ sender: Any) {
		self.startAcivityIndicator()
		//checks if text fields are not empty
		if let email = emailTextField.text, let password = passwordTextField.text {
			FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
				if ( error == nil ) {
					if let user = user {
						let userData = [Constants.DatabaseColumn.userEmail.rawValue: user.email!, Constants.DatabaseColumn.provider.rawValue: user.providerID, Constants.DatabaseColumn.profileImageUrl.rawValue: DEFAULT_PROFILE_IMAGE_URL] as [String : Any]
						self.updateActivityIndicator()
						self.saveUserDataToKeyChain(userId: user.uid, userData: userData)
					}
				} else {
					FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error ) in
						if ( error != nil ) {
							self.updateActivityIndicator()
						} else {
							if let user = user {
								let userData = [Constants.DatabaseColumn.userEmail.rawValue: user.email!, Constants.DatabaseColumn.provider.rawValue: user.providerID, Constants.DatabaseColumn.profileImageUrl.rawValue: DEFAULT_PROFILE_IMAGE_URL] as [String : Any]
								self.updateActivityIndicator()
								self.saveUserDataToKeyChain(userId: user.uid, userData: userData)
							}
						}
					})
				}
			})
		}
	}
	
	func saveUserDataToKeyChain(userId: String, userData: Dictionary<String, Any>) {
		DataService.shared.createFirbaseDBUser(uid: userId, userData: userData )
		KeychainWrapper.standard.set(userId, forKey: Constants.DatabaseColumn.userID.rawValue)
		performSegue(withIdentifier: Constants.ViewController.feedViewController.rawValue, sender: nil)
	}
	
	func updateActivityIndicator() {
		self.activityIndicator.stopAnimating()
		self.activityIndicator.isHidden = true
		UIApplication.shared.endIgnoringInteractionEvents()
	}
	
	func startAcivityIndicator() {
		self.activityIndicator.isHidden = false
		self.activityIndicator.startAnimating()
		UIApplication.shared.beginIgnoringInteractionEvents()
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








