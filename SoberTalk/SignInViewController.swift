//
//  SignInViewController.swift
//  SoberTalk
//
//  Created by Cons Bulaqueña on 21/04/2018.
//  Copyright © 2018 consios. All rights reserved.
//

import UIKit


class SignInViewController: UIViewController {
    @IBOutlet weak var anonymousLogin: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAnonymouslyDidTapped(_ sender: Any) {
        print("login did tapped")
        //anon login and switch views
        //switch view by setting nav controller as root controller

    }
    
    
    @IBAction func SignInDidTapped(_ sender: Any) {
        print("google login did tapped")
        //login google & switch view
        
        //create main storyboard instance, Switching views
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let naviVC = storyboard.instantiateViewController(withIdentifier: "NavigationVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = naviVC
        
    }
    
//end here
}
