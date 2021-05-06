//
//  AppScene.swift
//  Fit
//
//  Created by Beka Japaridze on 4/25/21.
//  Copyright © 2021 Beka Japaridze. All rights reserved.
//

import UIKit
import Firebase


class TabBarScene: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Fit"
        UINavigationBar.appearance().barTintColor = .black
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        UINavigationBar.appearance().isTranslucent = false




        navigationItem.hidesBackButton = true
        navigationController?.navigationBar.barStyle = .default
        //navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barStyle = .black
    }
    @IBAction func logOutPress(_ sender: UIBarButtonItem) {
       
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
