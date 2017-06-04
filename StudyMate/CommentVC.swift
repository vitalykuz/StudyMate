//
//  CommentVC.swift
//  StudyMate
//
//  Created by Vitaly Kuzenkov on 4/6/17.
//  Copyright © 2017 Vitaly Kuzenkov. All rights reserved.
//

import UIKit

class CommentVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	@IBAction func backImageTapped(_ sender: Any) {
		self.performSegue(withIdentifier: "unwindToMain", sender: self)
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
