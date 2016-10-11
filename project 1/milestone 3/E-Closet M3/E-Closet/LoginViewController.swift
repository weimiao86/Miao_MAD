//
//  LoginViewController.swift
//  E-Closet
//
//  Created by Wei Miao on 10/10/16.
//  Copyright © 2016 wei. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    //MARK: outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    
    //view funcs
    override func viewDidLoad() {
        emailTextField.delegate = self
        pwdTextField.delegate = self
        super.viewDidLoad()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    //MARK: funcs
    @IBAction func loginTouched(sender: UIButton) {
        if self.emailTextField.text == "" || self.pwdTextField.text == ""
        {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email and password.", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()?.signInWithEmail(self.emailTextField.text!, password: self.pwdTextField.text!) { (user, error) in
                
                if error == nil
                {
                    //get user id and pass it to operation view controller.
                }
                else
                {
                    let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func createTouched(sender: UIButton) {
        if self.emailTextField.text == "" || self.pwdTextField.text == ""
        {
            let alertController = UIAlertController(title: "Oops!", message: "Please enter an email and password.", preferredStyle: .Alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else
        {
            FIRAuth.auth()?.createUserWithEmail(self.emailTextField.text!, password: self.pwdTextField.text!) { (user, error) in
                
                if error == nil
                {
                    let alertController = UIAlertController(title: "Congratulations!", message: "Your accound has been created, Click Login to start!", preferredStyle: .Alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                else
                {
                    let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .Alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                
            }
        }
    }
    //pass current user id to operation view controller
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "userLogin"{
            let OperationViewController = segue.destinationViewController as! ViewController
            if let currentUser = FIRAuth.auth()?.currentUser {
                let userUid = currentUser.uid
                OperationViewController.userInfo.uid = userUid
                print(userUid)
            }
        }
    }
    // unwindSegue
    @IBAction func unwindSegue (segue:UIStoryboardSegue){
    }

}
