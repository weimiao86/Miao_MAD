//
//  ViewController.swift
//  Apartment Viewer
//
//  Created by Wei Miao on 9/1/16.
//  Copyright © 2016 wei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //flags to indicate interior or outside view
    var flag = 1
    var count = 1
    
    //MARK: Outlet
    @IBOutlet weak var viewDiscriptionText: UILabel!
    
    @IBOutlet weak var aptPics: UIImageView!
    
    //MARK: Functions
    //interior and outside view switch
    @IBAction func switchView(sender: UIButton) {
        count = 1
        let title = sender.titleForState(.Normal)!
        if (title == "Inside"){
            flag = 0
            viewDiscriptionText.text = "Interior view"
            aptPics.image = UIImage(named: "inside1")
        }
        else if(title == "Outside"){
            flag = 2
            viewDiscriptionText.text = "Outside view"
            aptPics.image = UIImage(named: "outside1")
        }
    }
    
    //Pictures switch of interior or outside view
    @IBAction func switchPics(sender: UIButton) {
        let btntitle = sender.titleForState(.Normal)!
        if(btntitle == "Next"){
            count = count+1
            if(count > 3){count = 3}
        }
        if(btntitle == "Previous"){
            count = count-1
            if(count < 1 ){count = 1}
        }
        
        if(flag == 0){
            switch count {
            case 1:
                aptPics.image = UIImage(named: "inside1")
            case 2:
                aptPics.image = UIImage(named: "inside2")
            case 3:
                aptPics.image = UIImage(named: "inside3")
            default:
                aptPics.image = UIImage(named: "inside1")
            }
        }
        if(flag == 2){
            switch count {
            case 1:
                aptPics.image = UIImage(named: "outside1")
            case 2:
                aptPics.image = UIImage(named: "outside2")
            case 3:
                aptPics.image = UIImage(named: "outside3")
            default:
                aptPics.image = UIImage(named: "outside1")
            }
        }
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

