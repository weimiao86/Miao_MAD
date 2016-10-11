//
//  ViewController.swift
//  E-Closet
//
//  Created by Wei Miao on 9/28/16.
//  Copyright © 2016 wei. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import AVKit
import AVFoundation
import MobileCoreServices

func getDocumentsURL() -> NSURL {
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    return documentsURL
}

func fileInDocumentsDirectory(filename: String) -> String {
    let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
    return fileURL.path!
}

var Timestamp: String {
    return String(format: "%.0f", (NSDate().timeIntervalSince1970 * 1000))
}
// class content
class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var avPlayerController: AVPlayerViewController?
    var image: UIImage?
    var lastChosenMediaType: String?
    var timer = NSTimer()
    
    //firebase init data
    var owner = ""
    var type = ""
    var color = ""
    //var data: NSData?
    var ownerSelected = 0
    var typeSelected = 0
    var colorSelected = 0
    let myImageName = "image.png"
    var urls = [String]()
    var index = 0
    var userInfo = user()
    var currentUid: String? {
        return userInfo.uid
    }
    var imageUrl: String? {
        return userInfo.imageUrl
    }
    //pick tage init data
    var ownerlist: [String]!
    var typelist: [String]!
    var colorlist: [String]!
    //outlets
    @IBOutlet weak var tagPicker: UIPickerView!
    @IBOutlet weak var clothViewer: UIImageView!
    @IBOutlet weak var takePictureBtn: UIBarButtonItem!
    @IBOutlet weak var tagPickerSeg: UISegmentedControl!
    
    //View Funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupData()
        self.tagPicker.dataSource = self
        self.tagPicker.delegate = self
        //check if camera availiable
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
        initUrlArray()
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: #selector(ViewController.initUrlArray), userInfo: nil, repeats: false)
    }
    
    //init url array
    func initUrlArray(){
        let userRef = FIRDatabase.database().reference().child(currentUid!)
        userRef.queryOrderedByChild("url").observeEventType(.ChildAdded, withBlock: { snapshot in
            if let allUrl = snapshot.value!["url"] as? String {
                if !self.urls.contains(allUrl){
                    self.urls.append(allUrl)
                }
            }
        })
        print("\(urls)")
        if !self.urls.isEmpty{
            if let url = NSURL(string: urls[index]) {
                if let data = NSData(contentsOfURL: url) {
                    //self.data = data
                    clothViewer.image = UIImage(data: data)
                }
            }
        }
    }
    //update query keys
    func updateQuery(){
        
        var owners = ""
        var types = ""
        var colors = ""
        var v1 = ""
        var v2 = ""
        var v3 = ""
        if self.ownerSelected == 1 {
            owners = "owner"
            v1 = self.owner
        }else{
            owners = ""
            v1 = ""
        }
        if self.typeSelected == 1 {
            types = "type"
            v2 = self.type
        }else{
            types = ""
            v2 = ""
        }
        if self.colorSelected == 1 {
            colors = "color"
            v3 = self.color
        }else{
            colors = ""
            v3 = ""
        }
        var keys = owners+types+colors
        var values = v1 + v2 + v3
        if keys == "" {
            keys = "owner"
        }
        if values == "" {
            values = "Dad"
        }
        print(keys)
        print(values)
        let userRef = FIRDatabase.database().reference().child(currentUid!)
        userRef.queryOrderedByChild(keys).queryEqualToValue(values).observeEventType(.ChildAdded, withBlock: { snapshot in
            let str1 = snapshot.value!["url"] as? String
            if !self.urls.contains(str1!){
                self.urls.append(str1!)
            }
        })
        //clothViewer.image = UIImage(data: NSData(contentsOfString: data))
        displayImage()
    }
    //display filtered image
    func displayImage(){
        if !urls.isEmpty {
            print("\(self.urls)")
            if let url = NSURL(string: urls[index]) {
                if let data = NSData(contentsOfURL: url) {
                    //self.data = data
                    clothViewer.image = UIImage(data: data)
                }
            }
        }
    }
    //update query
    func updateQuery2(){
        self.urls.removeAll()
        updateQuery()
        timer = NSTimer.scheduledTimerWithTimeInterval(2, target:self, selector: #selector(ViewController.updateQuery), userInfo: nil, repeats: false)
    }
    
    //updata imageview pics
    func updateDisplay() {
        if let mediaType = lastChosenMediaType {
            if mediaType == kUTTypeImage as NSString {
                clothViewer.image = UIImage(CGImage: image!.CGImage!, scale: 1, orientation:.Up)
            }
        }
    }
    
    //toolbar button functions
    @IBAction func previousPic(sender: UIBarButtonItem) {
        //clothViewer.image = UIImage(named: "c1")
        self.index -= 1
        if self.index < 0 {
            self.index = 0
        }
        if self.index > (urls.count - 1) {
            self.index = urls.count - 1
        }
        displayImage()
    }
    
    @IBAction func nextPic(sender: UIBarButtonItem) {
        //clothViewer.image = UIImage(named: "c2")
        self.index += 1
        if self.index < 0 {
            self.index = 0
        }
        if self.index > (urls.count - 1) {
            self.index = urls.count - 1
        }
        displayImage()
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
        if tagPickerSeg.selectedSegmentIndex == 0 {
        if component == 0 {
            if row == 0 {
                ownerSelected = 0
                self.owner = ""
                self.index = 0
                updateQuery2()
            }else if row == 1{
                ownerSelected = 1
                self.owner = "Dad"
                self.index = 0
                updateQuery2()
            }
            else if row == 2{
                ownerSelected = 1
                self.owner = "Mom"
                self.index = 0
                updateQuery2()
            }
            else if row == 3{
                ownerSelected = 1
                self.owner = "Son"
                self.index = 0
                updateQuery2()
            }
            else if row == 4{
                ownerSelected = 1
                self.owner = "Daughter"
                self.index = 0
                updateQuery2()
            }
        }
        
        if component == 1 {
            if row == 0 {
                typeSelected = 0
                self.type = ""
                self.index = 0
                updateQuery2()
            }else if row == 1 {
                typeSelected = 1
                self.type = "Tops"
                self.index = 0
                updateQuery2()
            }else if row == 2 {
                typeSelected = 1
                self.type = "Skirts"
                self.index = 0
                updateQuery2()
            }else if row == 3 {
                typeSelected = 1
                self.type = "Dresses"
                self.index = 0
                updateQuery2()
            }else if row == 4 {
                typeSelected = 1
                self.type = "Jackets"
                self.index = 0
                updateQuery2()
            }else if row == 5 {
                typeSelected = 1
                self.type = "Pants"
                self.index = 0
                updateQuery2()
            }else if row == 6 {
                typeSelected = 1
                self.type = "Shorts"
                self.index = 0
                updateQuery2()
            }else if row == 7 {
                typeSelected = 1
                self.type = "Coats"
                self.index = 0
                updateQuery2()
            }else if row == 8 {
                typeSelected = 1
                self.type = "SwimWear"
                self.index = 0
                updateQuery()
            }else if row == 9 {
                typeSelected = 1
                self.type = "Accessories"
                self.index = 0
                updateQuery2()
            }
        }
            
            if component == 2 {
                if row == 0 {
                    colorSelected = 0
                    self.color = ""
                    self.index = 0
                    updateQuery2()
                }else if row == 1 {
                    colorSelected = 1
                    self.color = "Red"
                    self.index = 0
                    updateQuery2()
                }else if row == 2 {
                    colorSelected = 1
                    self.color = "Green"
                    self.index = 0
                    updateQuery2()
                }
                else if row == 3 {
                    colorSelected = 1
                    self.color = "Yellow"
                    self.index = 0
                    updateQuery2()
                }
                else if row == 4 {
                    colorSelected = 1
                    self.color = "Blue"
                    self.index = 0
                    updateQuery2()
                }
                else if row == 5 {
                    colorSelected = 1
                    self.color = "Pink"
                    self.index = 0
                    updateQuery2()
                }
                else if row == 6 {
                    colorSelected = 1
                    self.color = "Purple"
                    self.index = 0
                    updateQuery2()
                }
                else if row == 7 {
                    colorSelected = 1
                    self.color = "Orange"
                    self.index = 0
                    updateQuery2()
                }
                else if row == 8 {
                    colorSelected = 1
                    self.color = "Black"
                    self.index = 0
                    updateQuery2()
                }else if row == 9 {
                    colorSelected = 1
                    self.color = "White"
                    self.index = 0
                    updateQuery2()
                }
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
    //choose picture to save, from local album or camera
    @IBAction func shootPicture(sender: UIBarButtonItem) {
        self.index = 0
        let alertController = UIAlertController(title: "Choose image from", message: "", preferredStyle: .Alert)
        let localAction = UIAlertAction(title: "Album", style: .Default, handler: {action in
            self.pickMediaFromSource(UIImagePickerControllerSourceType.PhotoLibrary)
        })
        let cameraAction = UIAlertAction(title: "Camera", style: .Default, handler: {action in
            self.pickMediaFromSource(UIImagePickerControllerSourceType.Camera)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(localAction)
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        self.presentViewController(alertController, animated: true, completion: nil)}
    //edit images tags
    @IBAction func editImageTag(sender: UIBarButtonItem) {
        if tagPickerSeg.selectedSegmentIndex == 1 {
            if !self.urls.isEmpty{
            let tempRef = FIRDatabase.database().reference().child(currentUid!).child("url")
            tempRef.queryEqualToValue(self.urls[index])
            let imageNmae = tempRef.key
            print(imageNmae)
            let owner = pickerView(tagPicker, titleForRow: tagPicker.selectedRowInComponent(0), forComponent: 0)
            let type = pickerView(tagPicker, titleForRow: tagPicker.selectedRowInComponent(1), forComponent: 1)
            let color = pickerView(tagPicker, titleForRow: tagPicker.selectedRowInComponent(2), forComponent: 2)
            let url = self.urls[index]
            let newRef = FIRDatabase.database().reference().child(imageNmae)
            let clothImage: [String: String] = [
                "owner": owner!,
                "type": type!,
                "color": color!,
                "ownertype": owner!+type!,
                "ownercolor": owner!+color!,
                "ownertypecolor": owner!+type!+color!,
                "url": url
            ]
            newRef.setValue(clothImage)
        }
        }
        updateQuery2()
    }
    //delete image and its tags
    @IBAction func DeleteImage(sender: UIBarButtonItem) {
        let tempRef = FIRDatabase.database().reference().child(currentUid!)
        if !self.urls.isEmpty{
            tempRef.queryOrderedByChild("url").queryEqualToValue(String(self.urls[index])).observeEventType(.Value, withBlock: { snapshot in
                    let alertController = UIAlertController(title: "Warning", message: "Are you sure to delete this image?", preferredStyle: .Alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .Default, handler: {action in
            //FIRDatabase.database().reference().child(self.currentUid!).child(imageNmae).removeValue()
            FIRDatabase.database().reference().child(self.currentUid!).child(snapshot.key).removeValue()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        })
        self.updateQuery2()
        }
    }
    // did finish picking image
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        lastChosenMediaType = info[UIImagePickerControllerMediaType] as? String
        if let mediaType = lastChosenMediaType {
            if mediaType == kUTTypeImage as NSString {
                image = info[UIImagePickerControllerEditedImage] as? UIImage
                let imagePath = fileInDocumentsDirectory(myImageName)
                saveImageLocal(image!, path: imagePath)
                uploadToStorage()
                sleep(1)
                saveImageData()
            }
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion:nil)
    }
    
    //save image to local
    func saveImageLocal(image: UIImage, path: String ) -> Bool{
        let pngImageData = UIImagePNGRepresentation(image)
        let result = pngImageData!.writeToFile(path, atomically: true)
        return result
    }
    //upload image data to database
    func saveImageData(){
        let picsRef = FIRDatabase.database().reference().child(currentUid!).child(Timestamp)
        let owner = pickerView(tagPicker, titleForRow: tagPicker.selectedRowInComponent(0), forComponent: 0)
        let type = pickerView(tagPicker, titleForRow: tagPicker.selectedRowInComponent(1), forComponent: 1)
        let color = pickerView(tagPicker, titleForRow: tagPicker.selectedRowInComponent(2), forComponent: 2)
        if let url = self.imageUrl{
        let clothImage: [String: String] = [
            "owner": owner!,
            "type": type!,
            "color": color!,
            "ownertype": owner!+type!,
            "ownercolor": owner!+color!,
            "ownertypecolor": owner!+type!+color!,
            "url": url
        ]
        picsRef.setValue(clothImage)
        }
    }
    //upload image to firebase
    func uploadToStorage(){
        let storage = FIRStorage.storage()
        let storageRef = storage.referenceForURL("gs://e-closet-7552d.appspot.com/")
        let uploadImage = NSURL(fileURLWithPath: fileInDocumentsDirectory(myImageName))
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/png"
        let imageName = String(Timestamp)
        let uploadTask = storageRef.child("\(currentUid!)/\(imageName)").putFile(uploadImage, metadata: metadata)
        uploadTask.observeStatus(.Success) { snapshot in
            // Upload completed successfully
            let dlRef = storageRef.child("\(self.currentUid!)/\(imageName)")
            // Fetch the download URL
            dlRef.downloadURLWithCompletion { (URL, error) -> Void in
                if (error != nil) {
                    // Handle any errors
                    //self.userinfo.text = "url not found"
                } else {
                    // Get the download URL
                    self.userInfo.imageUrl = String(URL!)
                    print(URL!)
        }
    }}}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}





















