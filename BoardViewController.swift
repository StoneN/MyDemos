//
//  BoardViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/19.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

enum Brushes: Int {
    case lineBrush
    case rectBrush
    case ellipseBrush
    case regularPolygonBrush
    case move
}

var segmentNum = 0
var edgeNum = 3

var brushWidthSliderValue: Float = 5.0
var brushColorPreviewBgcolor: UIColor = UIColor.black

class BoardViewController: UIViewController {
    
    @IBOutlet weak var board: Board!
    @IBOutlet weak var edgeNumTextField: UITextField!
   
    
  
    override func viewDidLoad() {
     
        super.viewDidLoad()
    }
  
    
    
    @IBAction func segmentValueChanged(_ sender: UISegmentedControl) {
        segmentNum = sender.selectedSegmentIndex
        if segmentNum == Brushes.regularPolygonBrush.rawValue {
            edgeNumTextField.isHidden = false
        } else {
            edgeNumTextField.isHidden = true
        }
    }
    
    @IBAction func setEdgeNum(_ sender: UITextField) {
        if let textValue = Int(sender.text!) {
            edgeNum = textValue > 3 ? textValue : 3
        }
        sender.resignFirstResponder()
    }
}

