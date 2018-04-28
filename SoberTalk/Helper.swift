//
//  Helper.swift
//  SoberTalk
//
//  Created by Cons Bulaqueña on 28/04/2018.
//  Copyright © 2018 consios. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit

//exist just once
class Helper {
    static let helper = Helper()
    
    func loginAnonymously() {
        //anon login and switch views
        //switch view by setting nav controller as root controller

        FIRAuth.auth()?.signInAnonymously(completion: { (anonymousUser: FIRUser?, error) in
            if error == nil {
                print("UserId: \(anonymousUser!.uid)")
                
                //create main storyboard instance, Switching views
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let naviVC = storyboard.instantiateViewController(withIdentifier: "NavigationVC")
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = naviVC
                
            } else {
                print(error!)
                return
            }
        })
        
        
    }
    
    func logInWithGoogle(){
    
}

