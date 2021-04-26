//
//  LogInController.swift
//  Fit
//
//  Created by Beka Japaridze on 4/23/21.
//  Copyright © 2021 Beka Japaridze. All rights reserved.
//

import UIKit

class LogInView: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailField.layer.cornerRadius = 17
        emailField.clipsToBounds = true
        passwordField.layer.cornerRadius = 17
        passwordField.clipsToBounds = true
        loginOutlet.layer.cornerRadius = 10
        
         navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    
}
