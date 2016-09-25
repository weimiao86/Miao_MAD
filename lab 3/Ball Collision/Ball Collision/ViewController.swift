//
//  ViewController.swift
//  Ball Collision
//
//  Created by Wei Miao on 9/24/16.
//  Copyright © 2016 wei. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK:outlets
    @IBOutlet weak var ball1Image: UIImageView!
    @IBOutlet weak var ball2Image: UIImageView!
    @IBOutlet weak var ball1Mass: UITextField!
    @IBOutlet weak var ball1Speed: UITextField!
    @IBOutlet weak var ball1Direction: UISegmentedControl!
    @IBOutlet weak var ball2Mass: UITextField!
    @IBOutlet weak var ball2Speed: UITextField!
    @IBOutlet weak var ball2Direction: UISegmentedControl!
    @IBOutlet weak var result: UILabel!
    
    
    //MARK:func
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        verifyValue()
    }
    
    // verify input value before caculation, alert users if input is invalid.
    func verifyValue(){
        let m1 = Double(ball1Mass.text!)
        let m2 = Double(ball2Mass.text!)
        let v1 = Double(ball1Speed.text!)
        let v2 = Double(ball2Speed.text!)
        // alert if m1 <= 0
        if m1 != nil{
            if m1! <= 0.0 {
                let massAlert=UIAlertController(title: "Warning", message: "The value of mass must be greater than 0", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction=UIAlertAction(title: "Cancel", style:UIAlertActionStyle.Cancel, handler: nil)
                massAlert.addAction(cancelAction)
                let okAction=UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:
                    {action in
                        self.ball1Mass.text = "1.0"
                    })
                massAlert.addAction(okAction)
                presentViewController(massAlert, animated: true, completion: nil)
                
            }
        }
        //alert if m2 <= 0
        if m2 != nil{
            if m2! <= 0.0 {
                let massAlert=UIAlertController(title: "Warning", message: "The value of mass must be greater than 0", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction=UIAlertAction(title: "Cancel", style:UIAlertActionStyle.Cancel, handler: nil)
                massAlert.addAction(cancelAction)
                let okAction=UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:
                    {action in
                        self.ball2Mass.text = "1.0"
                })
                massAlert.addAction(okAction)
                presentViewController(massAlert, animated: true, completion: nil)
            }
        }
        //alert if v1 < 0
        if v1 != nil {
            if v1! < 0 {
                let speedAlert = UIAlertController(title: "Warning", message: "the value of speed cannot be less than 0", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction=UIAlertAction(title: "OK", style:UIAlertActionStyle.Default, handler: {
                    action in
                        self.ball1Speed.text="0"
                })
                speedAlert.addAction(okAction)
                presentViewController(speedAlert, animated: true, completion: nil)
            }
        }
        //laert if v2 < 0
        if v2 != nil {
            if v2! < 0 {
                let speedAlert = UIAlertController(title: "Warning", message: "the value of speed cannot be less than 0", preferredStyle: UIAlertControllerStyle.Alert)
                let okAction=UIAlertAction(title: "OK", style:UIAlertActionStyle.Default, handler: {
                    action in
                    self.ball2Speed.text="0"
                })
                speedAlert.addAction(okAction)
                presentViewController(speedAlert, animated: true, completion: nil)
            }
        }
        
    }
    
    // return the collision result
    func collisionResult(M1 : Double, V1 : Double, M2 : Double, V2 : Double ){
        let V11 = (V1*(M1-M2)+2*M2*V2)/(M1+M2)  //speed of ball1 after collision
        let V22 = (V2*(M2-M1)+2*M1*V1)/(M1+M2)  //speed of ball2 after collision
        var str1: String
        var str2: String
        str1 = ""
        str2 = ""
        
        if V11 == 0 {
            str1 = "Ball1 stoped"
            ball1Image.image = UIImage(named: "ball1")
            
        }
        else if V11 > 0{
            str1 = "Ball1 moves right with speed " + String(format: "%.1f", (abs(V11)))
            ball1Image.image = UIImage(named: "ball1_right")
        }
        else if V11 < 0{
            str1 = "Ball1 moves left with speed " + String(format: "%.1f", (abs(V11)))
            ball1Image.image = UIImage(named: "ball1_left")
        }
        
        if V22 == 0{
            str2 = "Ball2 stoped"
            ball2Image.image = UIImage(named: "ball2")
        }
        else if V22 > 0{
            str2 = "Ball2 moves right with speed " + String(format: "%.1f", (abs(V22)))
            ball2Image.image = UIImage(named: "ball2_right")
        }
        else if V22 < 0{
            str2 = "Ball2 moves left with speed " + String(format: "%.1f", (abs(V22)))
            ball2Image.image = UIImage(named: "ball2_left")
        }
        //print result
        result.text = ("Result:\n" + str1 + "\n" + str2)
    }
    
    // switch ball1 moving direction image
    @IBAction func ball1DircSeg(sender: UISegmentedControl) {
        if ball1Direction.selectedSegmentIndex == 0 {
            ball1Image.image = UIImage(named: "ball1_left")
        }else if ball1Direction.selectedSegmentIndex == 1 {
            ball1Image.image = UIImage(named: "ball1_right")
        }
    }
    
    // switch ball2 moving direction image
    @IBAction func ball2DircSeg(sender: UISegmentedControl) {
        if ball2Direction.selectedSegmentIndex == 0 {
            ball2Image.image = UIImage(named: "ball2_left")
        }else if ball2Direction.selectedSegmentIndex == 1 {
            ball2Image.image = UIImage(named: "ball2_right")
        }
    }
    
    // excute the collision if users input is valid, otherwise, alert users.
    @IBAction func collision(sender: UIButton) {
        var m1: Double
        var v1 = 0.0
        var m2: Double
        var v2 = 0.0
        
        view.endEditing(true)
        
        if ball1Mass.text!.isEmpty {
            m1 = 1.0
        } else {
            m1 = Double(ball1Mass.text!)!
        }
        if ball1Speed.text!.isEmpty {
            v1 = 0.0
        } else {
            if ball1Direction.selectedSegmentIndex == 0 {
                v1 = -Double(ball1Speed.text!)!
            }else if ball1Direction.selectedSegmentIndex == 1 {
                v1 = Double(ball1Speed.text!)!
            }
        }
        
        if ball2Mass.text!.isEmpty {
            m2 = 1.0
        } else {
            m2 = Double(ball2Mass.text!)!
        }
        if ball2Speed.text!.isEmpty {
            v2 = 0.0
        } else {
            if ball2Direction.selectedSegmentIndex == 0 {
                v2 = -Double(ball2Speed.text!)!
            }else if ball2Direction.selectedSegmentIndex == 1 {
                v2 = Double(ball2Speed.text!)!
            }
        }
        
        if m1 >= 0 && m2 >= 0 && (v1-v2) > 0 {
            collisionResult(m1, V1 : v1, M2 : m2, V2 : v2 )
        }else{
            let alert = UIAlertController(title: "Warning", message: "Balls will not collide, please make sure they are moving towards each other, or a ball can catch another one if they are moving in the same direction.", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Got it", style: UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    // a tip for users
    @IBAction func tip(sender: UIButton) {
        let alert = UIAlertController(title: "Tip", message: "This is an elastic collision demonstration, the total momentum and kinetic energy of the two balls after the encounter is equal to their total momentum and kinetic energy before the encounter.", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Got it", style: UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    // tap gesture to hide keyboard when users touched background.
    @IBAction func onTapGestureRecognized(sender: UITapGestureRecognizer) {
        ball1Mass.resignFirstResponder()
        ball1Speed.resignFirstResponder()
        ball2Mass.resignFirstResponder()
        ball2Speed.resignFirstResponder()
    }

    override func viewDidLoad() {
        ball1Mass.delegate=self
        ball1Speed.delegate=self
        ball2Mass.delegate=self
        ball2Speed.delegate=self
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

