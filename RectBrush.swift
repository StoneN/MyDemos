//
//  RectBrush.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/19.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

class RectBrush: Brush {
    override func ownStroke(_ context: CGContext) {
        print("RestBrush's Stroke Here!")
        if let begin = self.begin, let end = self.end {
            let rect = CGRect(origin: CGPoint(x: min(begin.x, end.x), y: min(begin.y, end.y)), size: CGSize(width: abs(end.x - begin.x), height: abs(end.y - begin.y)))
            context.addRect(rect)
            context.setLineCap(.round)
            context.setLineWidth(self.strokeWidth)
            context.strokePath()
        }
    }
    
    override func isSelectBy(_ point: CGPoint) ->Bool {
        if let begin = self.begin, let end = self.end {
            let rect = CGRect(origin: CGPoint(x: min(begin.x, end.x), y: min(begin.y, end.y)), size: CGSize(width: abs(end.x - begin.x), height: abs(end.y - begin.y)))
            if rect.contains(point) {
                return true
            }
        }
        return false
    }
    
    override func getSelectedPath() -> UIBezierPath {
        let rectPath: UIBezierPath = UIBezierPath()
        if let begin = self.begin, let end = self.end {
            let rect = CGRect(origin: CGPoint(x: min(begin.x, end.x), y: min(begin.y, end.y)), size: CGSize(width: abs(end.x - begin.x), height: abs(end.y - begin.y)))
            let rectPathRef: CGMutablePath = .init()
            rectPathRef.addRect(rect)
            rectPath.cgPath = rectPathRef
            return rectPath
        }
        return rectPath
    }
}

