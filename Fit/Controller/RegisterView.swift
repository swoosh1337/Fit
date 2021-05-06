//
//  RegisterView.swift
//  Fit
//
//  Created by Beka Japaridze on 4/23/21.
//  Copyright © 2021 Beka Japaridze. All rights reserved.
//

import UIKit
import Firebase

class RegisterView: UIViewController {
//    @IBOutlet weak var emailTextField: UITextField!
//    @IBOutlet weak var createPasswordField: UITextField!
//    @IBOutlet weak var registerButton: UIButton!
    
    
 
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.layer.cornerRadius = 17
        emailTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 17
       passwordTextField.clipsToBounds = true
        registerButton.layer.cornerRadius = 10
        
         navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target:self,action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        if let email = emailTextField.text,  let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) {
                authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: K.fromRegister, sender: self)
                }
            }
       
       
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
         self.addKeyboardObserver()
     }

     override func viewWillDisappear(_ animated: Bool) {
         self.removeKeyboardObserver()
     }
    
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
        
    }
    
    
   
    
}

