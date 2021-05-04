//
//  ViewController.swift
//  Fit
//
//  Created by Beka Japaridze on 4/17/21.
//  Copyright © 2021 Beka Japaridze. All rights reserved.
//

import UIKit

class WelcomeView: UIViewController {
    @IBOutlet weak var signGoogle: UIButton!
    @IBOutlet weak var singFB: UIButton!
    @IBOutlet weak var logIn: UIButton!
    @IBOutlet weak var register: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signGoogle.layer.cornerRadius = 17
        singFB.layer.cornerRadius = 17
        logIn.layer.cornerRadius = 17
        register.layer.cornerRadius = 17
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
  
    
    
}





