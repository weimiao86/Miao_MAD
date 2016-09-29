//
//  ViewController.swift
//  E-Closet
//
//  Created by Wei Miao on 9/28/16.
//  Copyright © 2016 wei. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var avPlayerController: AVPlayerViewController?
    var image: UIImage?
    var movieURL: NSURL?
    var lastChosenMediaType: String?

    
    var ownerlist: [String]!
    var typelist: [String]!
    var colorlist: [String]!
    
    @IBOutlet weak var tagPicker: UIPickerView!
    @IBOutlet weak var clothViewer: UIImageView!
    @IBOutlet weak var takePictureBtn: UIBarButtonItem!
    
    //toolbar button functions
    @IBAction func previousPic(sender: UIBarButtonItem) {
        clothViewer.image = UIImage(named: "c1")
    }
    
    @IBAction func nextPic(sender: UIBarButtonItem) {
        clothViewer.image = UIImage(named: "c2")
    }
    
    
    // picker view data and delegate
    private func setupData(){
        self.ownerlist = ["All", "Dad", "Mom", "Son", "Daughter"]
        self.typelist = ["All", "Tops", "Skirts", "Dresses", "Jackets", "Pants", "Shorts", "Coats", "SwimWear", "Accessories"]
        self.colorlist = ["All", "Red", "Green", "Yellow", "Blue", "Pink", "Purple", "Orange", "Black", "White"]
        
    }
    
    // how many column to be displayed within picker view
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    
    // How many rows are there is each component
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return  self.ownerlist.count
        }
        if component == 1  {
            return self.typelist.count
        }
        if component == 2 {
            return self.colorlist.count
        }
        return 0
    }
    
    // title/content for row in given component
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            return self.ownerlist[row]
        }
        if component == 1 {
            return  self.typelist[row]
        }
        if component == 2 {
            return self.colorlist[row]
        }
        
        return "Invalid Row"
    }
    // called when row selected from any component within a picker view
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0 {
            // if first row then do
            if row == 0 {
                
            }else{
                
            }
        }
        
        if component == 1 {
            // if first row then set --
            if row == 0 {
                
            }else {
                
            }
        }
    }
    
    //UIPicker height attribute
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 16.0
    }
    //UIPicker text attribute
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
        {
            let pickerLabel = UILabel()
            switch component {
            case 0:
                pickerLabel.text = ownerlist[row]
                pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 16)
                pickerLabel.textColor = UIColor.blueColor()
                pickerLabel.textAlignment = NSTextAlignment.Center
            case 1:
                pickerLabel.text = typelist[row]
                pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 16)
                pickerLabel.textColor = UIColor.blueColor()
                pickerLabel.textAlignment = NSTextAlignment.Center
            case 2:
                pickerLabel.text = colorlist[row]
                pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 16)
                pickerLabel.textColor = UIColor.blueColor()
                pickerLabel.textAlignment = NSTextAlignment.Center
            default:
                return pickerLabel

            }
            
            return pickerLabel
    }
    
    //View Funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        self.tagPicker.dataSource = self
        self.tagPicker.delegate = self
        
        if !UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
            let alert = UIAlertController(title: "Warning", message: "No built-in camera on your device!", preferredStyle: UIAlertControllerStyle.Alert)
            let okAction=UIAlertAction(title: "OK", style:UIAlertActionStyle.Cancel, handler: nil)
            alert.addAction(okAction)
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateDisplay()
    }
    //camera funcs
    func updateDisplay() {
        if let mediaType = lastChosenMediaType {
            if mediaType == kUTTypeImage as NSString {
                //UIImage(
                //CGContextDrawImage(context, CGRectMake(0, 0, size.height, size.width), self.CGImage);
                //clothViewer.image = image!
                clothViewer.image = UIImage(CGImage: image!.CGImage!, scale: 1, orientation:.Left)
            }
        }
    }
    
    func pickMediaFromSource(sourceType:UIImagePickerControllerSourceType) {
        let mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(sourceType)!
        if UIImagePickerController.isSourceTypeAvailable(sourceType)
            && mediaTypes.count > 0 {
            let picker = UIImagePickerController()
            picker.mediaTypes = mediaTypes
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = sourceType
            presentViewController(picker, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title:"Error accessing media",
                                                    message: "Unsupported media source.",
                                                    preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "OK",
                                         style: UIAlertActionStyle.Cancel, handler: nil)
            alertController.addAction(okAction)
            presentViewController(alertController, animated: true, completion: nil)
        } }
    
    @IBAction func shootPicture(sender: UIBarButtonItem) {
        pickMediaFromSource(UIImagePickerControllerSourceType.Camera)
    }
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        lastChosenMediaType = info[UIImagePickerControllerMediaType] as? String
        if let mediaType = lastChosenMediaType {
            if mediaType == kUTTypeImage as NSString {
                image = info[UIImagePickerControllerEditedImage] as? UIImage
            } else if mediaType == kUTTypeMovie as NSString {
                movieURL = info[UIImagePickerControllerMediaURL] as? NSURL
            } }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion:nil)
    }




    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}





















