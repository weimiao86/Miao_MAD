//
//  ViewController.swift
//  Workout
//
//  Created by Qi Liu on 10/13/16.
//  Copyright © 2016 wei. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //Makrk: outlets
    @IBOutlet weak var workTimeTextField: UITextField!
    @IBOutlet weak var workoutTypeSeg: UISegmentedControl!
    @IBOutlet weak var workoutMiles: UILabel!
    @IBOutlet weak var workoutCal: UILabel!
    @IBOutlet weak var workoutImage: UIImageView!
    @IBOutlet weak var weeklySwitch: UISwitch!
    @IBOutlet weak var workoutAmount: UILabel!
    @IBOutlet weak var workoutAmountSlider: UISlider!
    
    //Makrk: variables
    var workoutTime = 0.0
    var isWeekly = 0
    var weeklyWorkout = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        workTimeTextField.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //Mark: funcs
    
    @IBAction func weeklySwitch(sender: UISwitch) {
        if weeklySwitch.on {
            isWeekly = 1
        }else{
            isWeekly = 0
        }
    }
    @IBAction func wokroutTypeSwitch(sender: UISegmentedControl) {
        if workoutTypeSeg.selectedSegmentIndex == 0{
            workoutImage.image = UIImage(named: "run")
        }else if workoutTypeSeg.selectedSegmentIndex == 1{
            workoutImage.image = UIImage(named: "swim")
        }else if workoutTypeSeg.selectedSegmentIndex == 2{
            workoutImage.image = UIImage(named: "bike")
        }
        }
    @IBAction func workoutSlider(sender: UISlider) {
        if weeklySwitch.on {
            let amount = sender.value
            workoutAmount.text = String(format: "%.2f", amount)
            weeklyWorkout = Double(amount)
        }
    }
    
    @IBAction func caculate(sender: UIButton) {
        if let time = workTimeTextField.text {
            workoutTime = Double(time)!
        
        if isWeekly == 0 {
            if workoutTypeSeg.selectedSegmentIndex == 0{
                let miles = workoutTime/10
                let calories = workoutTime*10
                workoutMiles.text = String(format: "%0.1f", miles)
                workoutCal.text = String(format: "%0.1f", calories)
            }else if workoutTypeSeg.selectedSegmentIndex == 1{
                let miles = workoutTime/4
                let calories = workoutTime*51/6
                workoutMiles.text = String(format: "%0.1f", miles)
                workoutCal.text = String(format: "%0.1f", calories)
            }else if workoutTypeSeg.selectedSegmentIndex == 2{
                let miles = workoutTime/30
                let calories = workoutTime*7
                workoutMiles.text = String(format: "%0.1f", miles)
                workoutCal.text = String(format: "%0.1f", calories)
            }
        }
        if isWeekly == 1{
            if workoutTypeSeg.selectedSegmentIndex == 0{
                let miles = workoutTime/10*weeklyWorkout
                let calories = workoutTime*10*weeklyWorkout
                workoutMiles.text = String(format: "%0.1f", miles)
                workoutCal.text = String(format: "%0.1f", calories)
            }else if workoutTypeSeg.selectedSegmentIndex == 1{
                let miles = workoutTime/4*weeklyWorkout
                let calories = workoutTime*51/6*weeklyWorkout
                workoutMiles.text = String(format: "%0.1f", miles)
                workoutCal.text = String(format: "%0.1f", calories)
            }else if workoutTypeSeg.selectedSegmentIndex == 2{
                let miles = workoutTime/30*weeklyWorkout
                let calories = workoutTime*7*weeklyWorkout
                workoutMiles.text = String(format: "%0.1f", miles)
                workoutCal.text = String(format: "%0.1f", calories)
            }
        }
        }
    }
    
    
    //TextFiled deleget
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let time = Int(workTimeTextField.text!)
        if time < 30 {
            let alert = UIAlertController(title: "Warning", message: "Workout time is too short!", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction=UIAlertAction(title: "OK", style:UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

