//
//  ViewController.swift
//  PokeWiki
//
//  Created by Wei Miao on 9/10/16.
//  Copyright © 2016 wei. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //flags
    var flag = "category flag"
    
    //MARK: Outlets
    @IBOutlet weak var pokemonPics: UIImageView!
    @IBOutlet weak var pokemonLabel: UILabel!
    @IBOutlet weak var pokemonPicker: UIPickerView!
    @IBOutlet weak var pokemonSegment: UISegmentedControl!
    @IBOutlet weak var textSizeLabel: UILabel!
    @IBOutlet weak var fontsegment: UISegmentedControl!
    @IBOutlet weak var pokeName: UILabel!
    @IBOutlet weak var capitalSwitch: UISwitch!
    @IBOutlet weak var fontsizeSlider: UISlider!
    
    //UIPicker datasource
    var pokemon = ["  ", "Pichu", "Bulbasaur", "Charmander", "Squirtle"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pokemonPicker.delegate = self
        self.pokemonPicker.dataSource = self
    }
    
    //MARK: functions
    
    //switch images when evolution segment touched
    func switchImage() {
        
            switch flag {
            case "Pichu":
                if pokemonSegment.selectedSegmentIndex == 0 {
                    pokemonPics.image = UIImage(named: "Pichu")
                    pokeName.text = "Pichu"
                }
                else if pokemonSegment.selectedSegmentIndex == 1 {
                    pokemonPics.image = UIImage(named: "Pikachu")
                    pokeName.text = "Pikachu"
                }
                else if pokemonSegment.selectedSegmentIndex == 2 {
                    pokemonPics.image = UIImage(named: "Raichu")
                    pokeName.text = "Raichu"
                }
            case "Bulbasaur":
                if pokemonSegment.selectedSegmentIndex == 0 {
                    pokemonPics.image = UIImage(named: "Bulbasaur")
                    pokeName.text = "Bulbasaur"
                }
                else if pokemonSegment.selectedSegmentIndex == 1 {
                    pokemonPics.image = UIImage(named: "Ivysaur")
                    pokeName.text = "Ivysaur"
                }
                else if pokemonSegment.selectedSegmentIndex == 2 {
                    pokemonPics.image = UIImage(named: "Venusaur")
                    pokeName.text = "Venusaur"
                }
            case "Charmander":
                if pokemonSegment.selectedSegmentIndex == 0 {
                    pokemonPics.image = UIImage(named: "Charmander")
                    pokeName.text = "Charmander"
                }
                else if pokemonSegment.selectedSegmentIndex == 1 {
                    pokemonPics.image = UIImage(named: "Charmeleon")
                    pokeName.text = "Charmeleon"
                }
                else if pokemonSegment.selectedSegmentIndex == 2 {
                    pokemonPics.image = UIImage(named: "Charizard")
                    pokeName.text = "Charizard"
                }
            case "Squirtle":
                if pokemonSegment.selectedSegmentIndex == 0 {
                    pokemonPics.image = UIImage(named: "Squirtle")
                    pokeName.text = "Squirtle"
                }
                else if pokemonSegment.selectedSegmentIndex == 1 {
                    pokemonPics.image = UIImage(named: "Wartortle")
                    pokeName.text = "Wartortle"
                }
                else if pokemonSegment.selectedSegmentIndex == 2 {
                    pokemonPics.image = UIImage(named: "Blastoise")
                    pokeName.text = "Blastoise"
                }
            default:
                pokemonPics.image = UIImage(named: "main")
            }
    }
    //swutch among 3 evolutions
    @IBAction func GenerationSegment(sender: UISegmentedControl) {
        switchImage()
    }
    
    //change pokemon discription text font and color when font segment touched
    @IBAction func fontSegment(sender: UISegmentedControl) {
        if fontsegment.selectedSegmentIndex == 0 {
            pokemonLabel.font = UIFont.systemFontOfSize(CGFloat(Int(fontsizeSlider.value)))
            pokemonLabel.textColor = UIColor.blueColor()
        }
        else if fontsegment.selectedSegmentIndex == 1 {
            pokemonLabel.font = UIFont.boldSystemFontOfSize(CGFloat(Int(fontsizeSlider.value)))
            pokemonLabel.textColor = UIColor.blackColor()
        }
        else if fontsegment.selectedSegmentIndex == 2 {
            pokemonLabel.font = UIFont.italicSystemFontOfSize(CGFloat(Int(fontsizeSlider.value)))
            pokemonLabel.textColor = UIColor.redColor()
        }
        }

    //change pokemon discription text size with slider
    @IBAction func textSizeSlider(sender: UISlider) {
        let fontsize = sender.value
        textSizeLabel.text = String(format: "%.0f", fontsize)
        let fontSizeCGFloat=CGFloat(fontsize)
        if fontsegment.selectedSegmentIndex == 0 {
        pokemonLabel.font=UIFont.systemFontOfSize(fontSizeCGFloat)
        }
        else if fontsegment.selectedSegmentIndex == 1 {
            pokemonLabel.font=UIFont.boldSystemFontOfSize(fontSizeCGFloat)
        }
        else if fontsegment.selectedSegmentIndex == 2 {
            pokemonLabel.font=UIFont.italicSystemFontOfSize(fontSizeCGFloat)
        }
        else {
            pokemonLabel.font=UIFont.systemFontOfSize(fontSizeCGFloat)
        }

        
    }
    
    //text capital switch
    @IBAction func capitalSwitch(sender: UISwitch) {
        if capitalSwitch.on {
            pokemonLabel.text = pokemonLabel.text?.uppercaseString
        } else {
            pokemonLabel.text = pokemonLabel.text?.capitalizedStringWithLocale(NSLocale.currentLocale())
        }
    }

    //UIPickerView delegate implement
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pokemon.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pokemon[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        flag = pokemon[row]
        
        switch flag {
            case "Pichu":
                pokemonSegment.selectedSegmentIndex = 0
                pokemonPics.image = UIImage(named: "Pichu")
                pokeName.text = "Pichu"
                pokemonLabel.text = "Type: Electric. Weaknesses: Ground"
            case "Bulbasaur":
                pokemonSegment.selectedSegmentIndex = 0
                pokemonPics.image = UIImage(named: "Bulbasaur")
                pokeName.text = "Bulbasaur"
                pokemonLabel.text = "Type: Grass. Weaknesses: Fire"
            case "Charmander":
                pokemonSegment.selectedSegmentIndex = 0
                pokemonPics.image = UIImage(named: "Charmander")
                pokeName.text = "Charmander"
                pokemonLabel.text = "Type: Fire. Weaknesses: Water"
            case "Squirtle":
                pokemonSegment.selectedSegmentIndex = 0
                pokemonPics.image = UIImage(named: "Squirtle")
                pokeName.text = "Squirtle"
                pokemonLabel.text = "Type: Water. Weaknesses: Electric"
            default:
                pokemonPics.image = UIImage(named: "main")
                pokeName.text = "Hello"
                pokemonLabel.text = "Welcome to pokemon world!"
            
        }
        
    }
    
    //UIPicker height attribute
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 20.0
    }
    
    //UIPicker text font attribute
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
        
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = pokemon[row]
        pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 18)
        //pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 15) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

