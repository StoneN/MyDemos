//
//  Brush.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/19.
//  Copyright © 2017年 StoneNan. All rights reserved.
//


import UIKit

protocol PaintBrush {
    func ownStroke(_ context: CGContext)
    func isSelectBy(_ point: CGPoint) -> Bool
    func getSelectedPath() -> UIBezierPath
}
class Brush: NSObject, PaintBrush {
    
    var begin: CGPoint!
    var end: CGPoint!
    
    var strokeWidth: CGFloat!
    var storkeColor: UIColor!
    
    func ownStroke(_ context: CGContext) {
        assert(false, "Must implements in subclass.")
    }
    func isSelectBy(_ point: CGPoint) -> Bool {
        assert(false, "Must implements in subclass.")
    }
    func getSelectedPath() -> UIBezierPath {
        assert(false, "Must implements in subclass.")
    }
    
}
