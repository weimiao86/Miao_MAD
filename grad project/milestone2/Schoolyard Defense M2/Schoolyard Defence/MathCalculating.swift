//
//  MathCalculating.swift
//  Schoolyard Defence
//
//  Created by Qi Liu on 10/29/16.
//  Copyright © 2016 wei. All rights reserved.
//

import UIKit
import AVFoundation

class MathCalculating: UIViewController, UITextFieldDelegate {
    
    var audioPlayer: AVAudioPlayer?
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var mathLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var resultTextField: UITextField!
    @IBOutlet weak var cannonImage: UIImageView!
    @IBOutlet weak var bearImage: UIImageView!
    @IBOutlet weak var resultImage: UIImageView!
    
    var p1 = 0;
    var p2 = 0;
    var opt = 0;
    var question = ""
    var result = 0
    var score = 0
    var steps = 5
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultTextField.delegate = self
        resultImage.alpha = 0
        //bear animation
        var monsterImageName = ["bear1","bear2","bear3","bear4","bear5","bear6",
                                "bear7","bear8","bear9","bear10","bear11","bear12",
                                "bear13","bear14","bear15","bear16","bear17"]
        var mImages = [UIImage]()
        for i in 0..<monsterImageName.count{
            mImages.append(UIImage(named: monsterImageName[i])!)
        }
        //cannon animation
        var cannonImageName = ["cannon1","cannon2","cannon3","cannon4","cannon5","cannon6",
                               "cannon7","cannon8","cannon9","cannon10","cannon11","cannon12",
                               "cannon13","cannon14","cannon15","cannon16","cannon17","cannon18",
                               "cannon19"]
        var cImages = [UIImage]()
        for i in 0..<cannonImageName.count{
            cImages.append(UIImage(named: cannonImageName[i])!)
        }
        
        cannonImage.animationImages = cImages
        cannonImage.animationDuration = 1
        
        bearImage.animationImages = mImages
        bearImage.animationDuration = 2.0
        bearImage.startAnimating()
        
        updateQuestion()
    }
    
    func updateQuestion(){
        p1 = Int(arc4random_uniform(98) + 1)
        p2 = Int(arc4random_uniform(98) + 1)
        opt = Int(arc4random_uniform(1) + 1)
        switch opt {
        case 1:
            question = "\(p1) + \(p2) ="
            result = p1+p2
        case 2:
            question = "\(p1) - \(p2) ="
            result = p1-p2
        default:
            question = "1 + 1 ="
            result = 2
        }
        mathLabel.text = question
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if let userResult = Int(resultTextField.text!){
            if userResult == result{
                self.resultImage.alpha = 1
                UIView.animateWithDuration(1.0, delay: 0.5, options: .CurveEaseInOut, animations: {
                    self.resultImage.transform = CGAffineTransformMakeScale(2.0, 2.0)
                    self.resultImage.image = UIImage(named: "correct")}, completion: {finished in
                        UIView.animateWithDuration(1.0, delay: 0.5, options: .CurveEaseInOut, animations: {
                            self.resultImage.transform = CGAffineTransformMakeScale(1.0, 1.0)
                            self.resultImage.alpha = 0}, completion: nil)})
                score += 10
                scoreLabel.text = "Score: \(score)"
                playAudio("cannon")
                cannonImage.animationRepeatCount = 1
                cannonImage.startAnimating()
                if(steps < 5){
                    bearBackward()
                    steps += 1;
                }
                if(steps > 5){
                    steps = 4
                }
                stepsLabel.text = "\(steps)"
                updateQuestion()
            }else{
                self.resultImage.alpha = 1
                UIView.animateWithDuration(1.0, delay: 0.5, options: .CurveEaseInOut, animations: {
                    self.resultImage.transform = CGAffineTransformMakeScale(2.0, 2.0)
                    self.resultImage.image = UIImage(named: "wrong")}, completion: {finished in
                        UIView.animateWithDuration(1.0, delay: 0.5, options: .CurveEaseInOut, animations: {
                            self.resultImage.transform = CGAffineTransformMakeScale(1.0, 1.0)
                            self.resultImage.alpha = 0}, completion: nil)})
                playAudio("cowmoo")
                bearForward()
                steps -= 1
                if(steps == 0){
                    gameOver()
                }
                stepsLabel.text = "\(steps)"
                
            }
            
        }
    }
    
    func bearForward(){
        UIView.animateWithDuration(1.0, delay: 0.5, options: .CurveEaseInOut, animations: {
            self.bearImage.transform = CGAffineTransformMakeScale(2.0, 2.0)
            }, completion: { finished in
                UIView.animateWithDuration(1.0, delay: 1.0, options: .CurveEaseInOut, animations: {
                    self.bearImage.transform = CGAffineTransformMakeTranslation(self.view.bounds.width/4, 0)
                    //self.monsterImage.center.x -= 20
                    }, completion: { finished in
                        UIView.animateWithDuration(1.0, delay: 0.5, options: .CurveEaseInOut, animations: {
                            self.bearImage.transform = CGAffineTransformMakeScale(1.0, 1.0)}, completion: nil)
                })
        })
    }
    func bearBackward(){
        UIView.animateWithDuration(1.0, delay: 0.5, options: .CurveEaseInOut, animations: {
            self.bearImage.transform = CGAffineTransformMakeScale(0.5, 0.5)
            }, completion: { finished in
                UIView.animateWithDuration(1.0, delay: 0.5, options: .CurveEaseInOut, animations: {
                    self.bearImage.transform = CGAffineTransformMakeScale(1.0, 1.0)}, completion: nil)})}
    
    func gameOver(){
        let alert = UIAlertController(title: "GamerOver", message: "Your score is \(score)", preferredStyle: UIAlertControllerStyle.Alert)
        let okAction=UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler:
            {action in
                self.score = 0
                self.steps = 5
                self.scoreLabel.text = "Score: " + "\(self.score)"
                self.stepsLabel.text = "\(self.steps)"
                self.updateQuestion()
        })
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: {action in
            self.playAudio("gameover")
        })
    }
    
    @IBAction func hint(sender: UIBarButtonItem) {
        playAudio("button")
        var str = ""
        if score > 0{
            str = "\(result)"
            score -= 5
            scoreLabel.text = "\(score)"
            if score < 0{
                score = 0
            }
        }else{
            str = "A hint costs 5 score, you do not have enough score!"
        }
        let alert=UIAlertController(title: "Hint", message: str, preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction=UIAlertAction(title: "OK", style:UIAlertActionStyle.Cancel, handler: nil)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func onTapGestureRecognized(sender: UITapGestureRecognizer) {
        resultTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    func playAudio(filename :String){
        let audioFilePath = NSBundle.mainBundle().pathForResource(filename, ofType: "mp3")
        let fileURL = NSURL(fileURLWithPath: audioFilePath!)
        audioPlayer = try? AVAudioPlayer(contentsOfURL: fileURL)
        if audioPlayer != nil{
            audioPlayer!.play()
        }
    }

}
