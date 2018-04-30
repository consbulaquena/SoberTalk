//
//  ChatViewController.swift
//  SoberTalk
//
//  Created by Cons Bulaqueña on 21/04/2018.
//  Copyright © 2018 consios. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutDidTapped(_ sender: Any) {
        
        //create main storyboard instance
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // from main instantiate a View(login) controller
        
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        
        //get app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        // set loginVC controller as root
        appDelegate.window?.rootViewController = loginVC
    }
    
}
