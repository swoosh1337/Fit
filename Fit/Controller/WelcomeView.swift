//
//  ViewController.swift
//  Fit
//
//  Created by Beka Japaridze on 4/17/21.
//  Copyright © 2021 Beka Japaridze. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class WelcomeView: UIViewController  {
   
 
    @IBOutlet weak var logIn: UIButton!
    @IBOutlet weak var register: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                 parameters: ["fields":"email,name"],
                                                 tokenString: token,
                                                 version: nil,
                                                 httpMethod: .get)
        request.start(completionHandler: {connection,result, error in
            print("\(result)")
        })
        self.performSegue(withIdentifier: "fbLogin", sender: self)
    }
    
//    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//        print("sasas")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if let token = AccessToken.current,
//                !token.isExpired {
//            let token = token.tokenString
//            
//            let request = FBSDKLoginKit.GraphRequest(graphPath: "me",
//                                                     parameters: ["fields":"email,name"],
//                                                     tokenString: token,
//                                                     version: nil,
//                                                     httpMethod: .get)
//            request.start(completionHandler: {connection,result, error in
//                print("\(result)")
//            })
            
//            self.performSegue(withIdentifier: "fbLogin", sender: self)
//            }
        
//        else
//            {
//        let loginButton = FBLoginButton()
//
//
//
//
//        loginButton.center = view.center
//                loginButton.layer.cornerRadius = 10
//        loginButton.delegate = self
//        loginButton.permissions = ["public_profile", "email"]
//        view.addSubview(loginButton)
        }
        
//        logIn.layer.cornerRadius = 17
//        register.layer.cornerRadius = 17
//      
//        
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        navigationController?.navigationBar.shadowImage = UIImage()
//        
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    
    
  
    
    






