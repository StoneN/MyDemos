//
//  BrushSettingViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/19.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

var redValue: Float! = 0
var greenValue: Float! = 0
var blueValue: Float! = 0

class BrushSettingViewController: UIViewController {
    
  
    @IBOutlet weak var brushWidthSlider: UISlider!
    @IBOutlet weak var brushColorPreview: UIView!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.brushWidthSlider.value = brushWidthSliderValue
        self.brushColorPreview.backgroundColor = brushColorPreviewBgcolor
        self.redSlider.value = redValue
        self.greenSlider.value = greenValue
        self.blueSlider.value = blueValue
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func save(_ sender: UIBarButtonItem) {
        redValue = redSlider.value
        greenValue = greenSlider.value
        blueValue = blueSlider.value
        
        brushWidthSliderValue = brushWidthSlider.value
        brushColorPreviewBgcolor = brushColorPreview.backgroundColor!
        dismiss(animated: true, completion: nil)
    }


    @IBAction func redValueChanged(_ sender: UISlider) {
        brushColorPreview.backgroundColor = UIColor(colorLiteralRed: redSlider.value, green: greenSlider.value, blue: blueSlider.value, alpha: 1)
    }
    
    @IBAction func greenValueChanged(_ sender: UISlider) {
        brushColorPreview.backgroundColor = UIColor(colorLiteralRed: redSlider.value, green: greenSlider.value, blue: blueSlider.value, alpha: 1)
    }

    @IBAction func blueValueChanged(_ sender: UISlider) {
        brushColorPreview.backgroundColor = UIColor(colorLiteralRed: redSlider.value, green: greenSlider.value, blue: blueSlider.value, alpha: 1)
    }
   
}

