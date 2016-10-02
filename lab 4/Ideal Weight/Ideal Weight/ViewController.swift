
//
//  ViewController.swift
//  Ideal Weight
//
//  Created by Wei Miao on 9/29/16.
//  Copyright © 2016 wei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Mark: outlets
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var age: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var weight: UILabel!
    @IBOutlet weak var goView2: UIBarButtonItem!
    
    var userinfo = body()
    
    //Mark: funcs
    @IBAction func unwindSegue (segue:UIStoryboardSegue){
        age.text = "Age: " + "\(userinfo.age!)"
        gender.text = "Gender: " + userinfo.gender!
        height.text = "Height: " + String(format: "%.1f", (userinfo.height!))
        weight.text = "Weight: " + String(format: "%.1f", (userinfo.weight!))
        updateResult()
        goView2.image = UIImage(named: "refresh")
    }
    //update users info
    func updateResult(){
        let bmi = 703*userinfo.weight!/(userinfo.height!*userinfo.height!)
        let weightmin = 18.5*(userinfo.height!*userinfo.height!)/703
        let weightmax = 25*(userinfo.height!*userinfo.height!)/703
        result.text = "Your BMI is: " + String(format: "%.1f", bmi) + "\n" +
                        "Your recommended weight is: \n" + String(format: "%.1f",(weightmin)) + "lb - " + String(format: "%.1f", (weightmax)) + "lb." + "\n" + "Your info as below:"
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

