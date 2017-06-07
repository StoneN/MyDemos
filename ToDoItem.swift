//
//  ToDoItem.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/31.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

class ToDoItem: NSObject {
    
    var id: String
    var image: String
    var title: String
    var date: Date
    
    init(id: String, image: String, title: String, date: Date) {
        self.id = id
        self.image = image
        self.title = title
        self.date = date
    }
}
