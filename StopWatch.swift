//
//  StopWatch.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/23.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import Foundation

class StopWatch: NSObject {
    var counter: Double
    var timer: Timer
    
    override init() {
        self.counter = 0.0
        self.timer = Timer()
    }
}
