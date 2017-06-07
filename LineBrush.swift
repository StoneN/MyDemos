//
//  LineBrush.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/19.
//  Copyright © 2017年 StoneNan. All rights reserved.
//


import UIKit

class LineBrush: Brush {
    
    override func ownStroke(_ context: CGContext) {
        if let begin = self.begin, let end = self.end {
            print("MMP!")
            context.move(to: begin)
            context.addLine(to: end)
            context.setLineCap(.round)
            context.setLineWidth(self.strokeWidth)
            context.strokePath()
        }
    }
    
    override func isSelectBy(_ point: CGPoint) ->Bool {
        if let begin = self.begin, let end = self.end {
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
                let x = begin.x + t * (end.x - begin.x)
                let y = begin.y + t * (end.y - begin.y)
                
                if hypot(x - point.x, y - point.y) < 10.0 {
                    return true
                }
            }
        }
        return false
    }
    
    override func getSelectedPath() -> UIBezierPath {
        let linePath: UIBezierPath = UIBezierPath()
        if let begin = self.begin, let end = self.end {
            linePath.move(to: begin)
            linePath.addLine(to: end)
            return linePath
        }
        return linePath
    }
}


