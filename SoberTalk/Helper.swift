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
import GoogleSignIn
import FirebaseDatabase


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
                self.switchToNavigationViewController()
                
            } else {
                print(error!)
                return
            }
        })
        
        
    }
    
    
    func logInWithGoogle(authentication: GIDAuthentication) {
    let credential = FIRGoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        


    FIRAuth.auth()?.signIn(with: credential, completion: { (user: FIRUser?, error: Error?) in
    if error != nil {
    print(error!.localizedDescription)
    return
    } else {
        print(user?.email)
    print(user?.displayName)
    print(user?.photoURL)
    
    let newUser = FIRDatabase.database().reference().child("users").child(user!.uid)
    newUser.setValue(["displayname" : "\(user!.displayName!)", "id" : "\(user!.uid)",
    "profileUrl": "\(user!.photoURL!)"])
    
    
    self.switchToNavigationViewController()
    }
    })
    }

func switchToNavigationViewController() {
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let naviVC = storyboard.instantiateViewController(withIdentifier: "NavigationVC") as! UINavigationController
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.window?.rootViewController = naviVC
    
}


}

