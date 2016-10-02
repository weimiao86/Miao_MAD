//
//  userInfoCollector.swift
//  Ideal Weight
//
//  Created by Qi Liu on 9/29/16.
//  Copyright © 2016 wei. All rights reserved.
//

import UIKit

class userInfoCollector: UIViewController, UITextFieldDelegate {
    //mark: outlets
    @IBOutlet weak var age: UITextField!
    @IBOutlet weak var gender: UITextField!
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var weight: UITextField!
    

    override func viewDidLoad() {
        age.delegate = self
        gender.delegate = self
        height.delegate = self
        weight.delegate = self
        super.viewDidLoad()
    }
    
    //UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        verifydata()
    }
    //verify users input, pop alert when invalid
    func verifydata(){
        let userage = Int(age.text!)
        let userheight = Float(height.text!)
        let userweight = Float(weight.text!)
        if userage != nil {
            if userage < 18 {
                let alert = UIAlertController(title: "Warning", message: "Age must be greater than 18.", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "Got it", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(okAction)
                presentViewController(alert, animated: true, completion: nil)
            }
        }
        if userheight != nil{
            if userheight <= 0 {
                let alert = UIAlertController(title: "Warning", message: "weight must be greater than 0.", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "Got it", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(okAction)
                presentViewController(alert, animated: true, completion: nil)
            }
        }
        if userweight != nil{
            if userweight <= 0 {
                let alert = UIAlertController(title: "Warning", message: "Weight must be greater than 18.", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction = UIAlertAction(title: "Got it", style: UIAlertActionStyle.Cancel, handler: nil)
                alert.addAction(okAction)
                presentViewController(alert, animated: true, completion: nil)
            }
        }

    }
    
    // tap gesture to hide keyboard when users touched background.
    @IBAction func onTapGestureRecognized(sender: UITapGestureRecognizer) {
        age.resignFirstResponder()
        gender.resignFirstResponder()
        height.resignFirstResponder()
        weight.resignFirstResponder()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "returninfo"{
            let scene1ViewController = segue.destinationViewController as! ViewController
            if age.text?.isEmpty == false{
                scene1ViewController.userinfo.age = Int(age.text!)
            }
            if gender.text?.isEmpty == false{
                scene1ViewController.userinfo.gender = gender.text
            }
            if height.text?.isEmpty == false{
                scene1ViewController.userinfo.height = Float(height.text!)
            }
            if weight.text?.isEmpty == false{
                scene1ViewController.userinfo.weight = Float(weight.text!)
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
