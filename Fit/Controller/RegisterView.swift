//
//  RegisterView.swift
//  Fit
//
//  Created by Beka Japaridze on 4/23/21.
//  Copyright © 2021 Beka Japaridze. All rights reserved.
//

import UIKit

class RegisterView: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var createPasswordField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.layer.cornerRadius = 17
        emailTextField.clipsToBounds = true
        createPasswordField.layer.cornerRadius = 17
        createPasswordField.clipsToBounds = true
        registerButton.layer.cornerRadius = 10
        
         navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target:self,action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
        
    }
    
    
   
    
}
