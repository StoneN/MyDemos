//
//  Board.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/19.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit


class Board: UIView {

    var currentBrush: Brush?
    var finishedBrushes: [Brush] = []
    weak var selectedBrush: Brush?
    var moveRecognizer: UIPanGestureRecognizer?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches Began!")
        self.getCurrentBrush()
        if let currentBrush = self.currentBrush {
            let touch = touches.first! as UITouch
            currentBrush.begin = touch.location(in: self)
            currentBrush.end = currentBrush.begin
            self.setNeedsDisplay()
        }
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches Moved!")
        if let currentBrush = self.currentBrush {
            let touch = touches.first! as UITouch
            currentBrush.end = touch.location(in: self)
            self.setNeedsDisplay()
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touches Ended!")
        if let currentBrush = self.currentBrush {
            self.finishedBrushes.append(currentBrush)
        }
        self.currentBrush = nil
        self.setNeedsDisplay()
    }
    
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        if !self.finishedBrushes.isEmpty {
            
            UIColor.black.set()
            for brush in self.finishedBrushes {
                brush.storkeColor.set()
                brush.ownStroke(context!)
            }
        }
        if let currentBrush = self.currentBrush {
            UIColor.red.set()
            currentBrush.ownStroke(context!)
        }
        if let selectedBrush = self.selectedBrush {
            UIColor.green.set()
            selectedBrush.ownStroke(context!)
        }
    }
    
    func takeImage() -> UIImage {
        UIGraphicsBeginImageContext(self.bounds.size)
        self.backgroundColor?.setFill()
        UIRectFill(self.bounds)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}





extension Board: UIGestureRecognizerDelegate {
    
    func tap(gr: UIGestureRecognizer) {
        let tappedPoint = gr.location(in: self)
        for brush in finishedBrushes {
            if brush.isSelectBy(tappedPoint) {
                self.selectedBrush = brush
                self.setNeedsDisplay()
                return
            }
        }
        self.selectedBrush = nil
        self.setNeedsDisplay()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.moveRecognizer {
            return true
        }
        return false
    }
    
    func move(gr: UIPanGestureRecognizer) {
        guard let selectedBrush = self.selectedBrush else {
            return
        }
        if gr.state == UIGestureRecognizerState.changed {
            let translation = gr.translation(in: self)
            var begin = selectedBrush.begin
            var end = selectedBrush.end
            
            begin?.x += translation.x
            begin?.y += translation.y
            end?.x += translation.x
            end?.y += translation.y
            
            self.selectedBrush?.begin = begin
            self.selectedBrush?.end = end
            
            self.setNeedsDisplay()
            gr.setTranslation(CGPoint.zero, in: self)
        }
    }
    
    // MARK: Helper
    func getCurrentBrush() {
        let tapRecognizer: UITapGestureRecognizer = .init(target: self, action: #selector(tap(gr:)))
        let moveRecognizer: UIPanGestureRecognizer = .init(target: self, action: #selector(move(gr:)))
        moveRecognizer.delegate = self
        moveRecognizer.cancelsTouchesInView = false
        
        switch segmentNum {
        case Brushes.lineBrush.rawValue:
            self.selectedBrush = nil
            self.currentBrush = LineBrush()
            
            self.currentBrush?.strokeWidth = CGFloat(brushWidthSliderValue)
            self.currentBrush?.storkeColor = brushColorPreviewBgcolor
            
            self.addGestureRecognizer(tapRecognizer)
            self.removeGestureRecognizer(moveRecognizer)
            
        case Brushes.rectBrush.rawValue:
            self.selectedBrush = nil
            self.currentBrush = RectBrush()
            
            self.currentBrush?.strokeWidth = CGFloat(brushWidthSliderValue)
            self.currentBrush?.storkeColor = brushColorPreviewBgcolor
            
            self.addGestureRecognizer(tapRecognizer)
            self.removeGestureRecognizer(moveRecognizer)
            
        case Brushes.ellipseBrush.rawValue:
            self.selectedBrush = nil
            self.currentBrush = EllipseBrush()
            
            self.currentBrush?.strokeWidth = CGFloat(brushWidthSliderValue)
            self.currentBrush?.storkeColor = brushColorPreviewBgcolor
            
            self.addGestureRecognizer(tapRecognizer)
            self.removeGestureRecognizer(moveRecognizer)
            
        case Brushes.regularPolygonBrush.rawValue:
            self.selectedBrush = nil
            self.currentBrush = RegularPolygonBrush(edgeNum)
            
            self.currentBrush?.strokeWidth = CGFloat(brushWidthSliderValue)
            self.currentBrush?.storkeColor = brushColorPreviewBgcolor
            
            self.addGestureRecognizer(tapRecognizer)
            self.removeGestureRecognizer(moveRecognizer)
            
        case Brushes.move.rawValue:
            self.currentBrush = nil
            self.addGestureRecognizer(moveRecognizer)
            
        default:
            return
        }
    }
}


extension Int {
    var degreesToRadians: Double { return Double(self) * .pi / 180 }
}
extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}


