//
//  FeedVC.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 8/5/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper
import Firebase

class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	@IBAction func signOutButtonTapped(_ sender: Any) {
		KeychainWrapper.standard.removeObject(forKey: KEY_UID)
		try! FIRAuth.auth()?.signOut()
		performSegue(withIdentifier: "toSignInVC", sender: nil)
	}

}
