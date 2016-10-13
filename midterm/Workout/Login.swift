//
//  Login.swift
//  Workout
//
//  Created by Qi Liu on 10/13/16.
//  Copyright © 2016 wei. All rights reserved.
//

import UIKit

class Login: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    
    override func viewDidLoad() {
        username.delegate = self
        email.delegate = self
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func unwindSegue (segue:UIStoryboardSegue){
    }

}
