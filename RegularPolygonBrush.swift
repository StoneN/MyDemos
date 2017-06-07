//
//  RegularPolygonBrush.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/19.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

class RegularPolygonBrush: Brush {
    
    var edgeNum: Int!
    
    init(_ edgeNum: Int) {
        self.edgeNum = edgeNum
    }
    
    override func ownStroke(_ context: CGContext) {
        if let begin = self.begin, let end = self.end {
            let radius: CGFloat = hypot(abs(end.x - begin.x), abs(end.y - begin.y))
            let firstPoint = CGPoint(x: begin.x + radius, y: begin.y)
            var pointsCount = 1
            context.move(to: firstPoint)
            let circlePath = UIBezierPath()
            circlePath.move(to: firstPoint)
            while pointsCount < self.edgeNum {
                let endAngle = (2 * Double(pointsCount) / Double(self.edgeNum)) * Double.pi
                circlePath.addArc(withCenter: begin, radius: radius, startAngle: 0, endAngle: CGFloat(endAngle), clockwise: true)
                pointsCount = pointsCount + 1
                context.addLine(to: circlePath.currentPoint)
            }
            context.addLine(to: firstPoint)
            context.setLineCap(.round)
            context.setLineWidth(self.strokeWidth)
            context.strokePath()
        }
    }
    
    override func isSelectBy(_ point: CGPoint) ->Bool {
        
        if let begin = self.begin, let end = self.end {
            let path: UIBezierPath! = UIBezierPath()
            let radius: CGFloat = hypot(abs(end.x - begin.x), abs(end.y - begin.y))
            let firstPoint = CGPoint(x: begin.x + radius, y: begin.y)
            var pointsCount = 1
            let circlePath = UIBezierPath()
            circlePath.move(to: firstPoint)
            path.move(to: firstPoint)
            while pointsCount < self.edgeNum {
                let endAngle = (2 * Double(pointsCount) / Double(self.edgeNum)) * Double.pi
                circlePath.addArc(withCenter: begin, radius: radius, startAngle: 0, endAngle: CGFloat(endAngle), clockwise: true)
                pointsCount = pointsCount + 1
                path.addLine(to: circlePath.currentPoint)
            }
            path.close()
            if path.contains(point) {
                return true
            }
        }
        return false
    }
}

