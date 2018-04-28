//
//  SignInViewController.swift
//  SoberTalk
//
//  Created by Cons Bulaqueña on 21/04/2018.
//  Copyright © 2018 consios. All rights reserved.
//

import UIKit
import GoogleSignIn


class SignInViewController: UIViewController {
    @IBOutlet weak var anonymousLogin: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for Google to recognize app
        GIDSignIn.sharedInstance().clientID = "41656059468-5eesbuco3h7gr6vm4r8n65mss0uvaef4.apps.googleusercontent.com"
        
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
        Helper.helper.loginAnonymously()
        
    }
    
    
    @IBAction func SignInDidTapped(_ sender: Any) {
        print("google login did tapped")
        //login google & switch view
        GIDSignIn.sharedInstance().signIn()
        Helper.helper.logInWithGoogle()
        
        
        
        //create main storyboard instance, Switching views
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let naviVC = storyboard.instantiateViewController(withIdentifier: "NavigationVC")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = naviVC
        
    }
    
//end here
}
