//
//  LogInController.swift
//  Fit
//
//  Created by Beka Japaridze on 4/23/21.
//  Copyright © 2021 Beka Japaridze. All rights reserved.
//

import UIKit
import Firebase

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
        
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target:self,action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        
       
        
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
 
    
    @IBAction func loginUser(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text {
            Auth.auth().signIn(withEmail:email, password: password){ [weak self] authResult,error
                in guard let strongSelf = self else {return}
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    self!.performSegue(withIdentifier: K.fromLogin, sender: self)
                }
            }
        }
    }
    
}
    
    
    

extension UIViewController {
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotifications(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }

    func removeKeyboardObserver(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    // This method will notify when keyboard appears/ dissapears
    @objc func keyboardNotifications(notification: NSNotification) {

        var txtFieldY : CGFloat = 0.0  //Using this we will calculate the selected textFields Y Position
        let spaceBetweenTxtFieldAndKeyboard : CGFloat = 5.0 //Specify the space between textfield and keyboard


        var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        if let activeTextField = UIResponder.currentFirst() as? UITextField ?? UIResponder.currentFirst() as? UITextView {
            // Here we will get accurate frame of textField which is selected if there are multiple textfields
            frame = self.view.convert(activeTextField.frame, from:activeTextField.superview)
            txtFieldY = frame.origin.y + frame.size.height
        }

        if let userInfo = notification.userInfo {
            // here we will get frame of keyBoard (i.e. x, y, width, height)
            let keyBoardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let keyBoardFrameY = keyBoardFrame!.origin.y
            let keyBoardFrameHeight = keyBoardFrame!.size.height

            var viewOriginY: CGFloat = 0.0
            //Check keyboards Y position and according to that move view up and down
            if keyBoardFrameY >= UIScreen.main.bounds.size.height {
                viewOriginY = 0.0
            } else {
                // if textfields y is greater than keyboards y then only move View to up
                if txtFieldY >= keyBoardFrameY {

                    viewOriginY = (txtFieldY - keyBoardFrameY) + spaceBetweenTxtFieldAndKeyboard

                    //This condition is just to check viewOriginY should not be greator than keyboard height
                    // if its more than keyboard height then there will be black space on the top of keyboard.
                    if viewOriginY > keyBoardFrameHeight { viewOriginY = keyBoardFrameHeight }
                }
            }

            //set the Y position of view
            self.view.frame.origin.y = -viewOriginY
        }
    }
}

extension UIResponder {

    static weak var responder: UIResponder?

    static func currentFirst() -> UIResponder? {
        responder = nil
        UIApplication.shared.sendAction(#selector(trap), to: nil, from: nil, for: nil)
        return responder
    }

    @objc private func trap() {
        UIResponder.responder = self
    }
}
