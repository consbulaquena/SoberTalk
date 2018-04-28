//
//  SignInViewController.swift
//  SoberTalk
//
//  Created by Cons Bulaqueña on 21/04/2018.
//  Copyright © 2018 consios. All rights reserved.
//

import UIKit
import FirebaseAuth

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
        //anon login and switch views
        //switch view by setting nav controller as root controller
        
        FIRAuth.auth()?.signInAnonymously(completion: { (anonymousUser: FIRUser?, error) in
            if error == nil {
                print("UserId: \(anonymousUser!.uid)")
            } else {
                print(error!)
                return
            }
        })
        
        
        //create main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // from main instantiate a nav controller

         let naviVC = storyboard.instantiateViewController(withIdentifier: "NavigationVC")
        
        //get app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        // set nav controller as root
        appDelegate.window?.rootViewController = naviVC
        
    }
    
    
    @IBAction func SignInDidTapped(_ sender: Any) {
        //login google & switch view
        
    }
    
//end here
}
