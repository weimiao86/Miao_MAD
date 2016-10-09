//
//  ViewController.swift
//  Labrador
//
//  Created by Wei Miao on 10/8/16.
//  Copyright © 2016 wei. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    var audioPlayer: AVAudioPlayer?
    var flag = 0
    
    @IBOutlet weak var pics: UIImageView!
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    //MARK: Funcs
    //hanlde tap
    @IBAction func handleTap(sender: UITapGestureRecognizer) {
        pics.image = UIImage(named: "labrador")
        playAudio("idle")
        flag = 1
    }
    //handle pan
    @IBAction func handlePan(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        sender.view!.center = CGPoint(x: sender.view!.center.x + translation.x, y: sender.view!.center.y + translation.y)
        sender.setTranslation(CGPointZero, inView: view)
        if sender.state == UIGestureRecognizerState.Ended {
            let velocity = sender.velocityInView(self.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 500
            
            //if the length is < 200, then decrease the base speed, otherwise increase it
            let slideFactor = 0.1 * slideMultiplier //increase for a greater slide
            
            //calculate a final point based on the velocity and the slideFactor
            var finalPoint = CGPoint(x:sender.view!.center.x + (velocity.x * slideFactor), y:sender.view!.center.y + (velocity.y * slideFactor))
            
            //make sure the final point is within the view’s bounds
            finalPoint.x = min(max(finalPoint.x, 0), self.view.bounds.size.width)
            finalPoint.y = min(max(finalPoint.y, 0), self.view.bounds.size.height)
            
            //animate the view
            UIView.animateWithDuration(Double(slideFactor * 2), delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {sender.view!.center = finalPoint }, completion: nil)
        }
        
    }
    //handle pinch
    @IBAction func handlePinch(sender: UIPinchGestureRecognizer) {
        sender.view!.transform = CGAffineTransformScale(sender.view!.transform, sender.scale, sender.scale)
        sender.scale=1
    }
    //handle rotation
    @IBAction func handleRotate(sender: UIRotationGestureRecognizer) {
        pics.image = UIImage(named: "labrador-rolling")
        playAudio("hahaha")
        sender.view!.transform = CGAffineTransformRotate(sender.view!.transform, sender.rotation)
        sender.rotation=0
        
    }
    //handle longpress
    @IBAction func handleLongPress(sender: UILongPressGestureRecognizer) {
        if (sender.state == UIGestureRecognizerState.Ended) {
            pics.image = UIImage(named: "labrador")
        }
        else if (sender.state == UIGestureRecognizerState.Began){
            playAudio("growup")
            pics.image = UIImage(named: "labrador_adult")
        }
    }
    
    func playAudio(filename :String){
        let audioFilePath = NSBundle.mainBundle().pathForResource(filename, ofType: "mp3")
        let fileURL = NSURL(fileURLWithPath: audioFilePath!)
        audioPlayer = try? AVAudioPlayer(contentsOfURL: fileURL)
        if audioPlayer != nil{
            audioPlayer!.play()
        }

    }
    //view funcs
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

