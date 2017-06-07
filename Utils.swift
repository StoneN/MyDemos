//
//  Utils.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/31.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

func dateFromString(_ date: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.date(from: date)
}

func stringFromDate(_ date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    return dateFormatter.string(from: date)
}

func setMessageLabel(_ messageLabel: UILabel, frame: CGRect, text: String, textColor: UIColor, numberOfLines: Int, textAlignment: NSTextAlignment, font: UIFont) {
    messageLabel.frame = frame
    messageLabel.text = text
    messageLabel.textColor = textColor
    messageLabel.numberOfLines = numberOfLines
    messageLabel.textAlignment = textAlignment
    messageLabel.font = font
    messageLabel.sizeToFit()
}
