//
//  PtTagsColorsTableViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/6/1.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

struct TagsColorTableData {
    var label: String
    var color: UIColor?
}

class PtTagsColorsTableViewController: UITableViewController {

    // MARK: - Properties
    var data: [TagsColorTableData]?
    
    // MARK: - UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = data else {
            return 0
        }
        
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let data = data else {
            fatalError("Application error no cell data available")
        }
        
        let cellData = data[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TagOrColorCell", for: indexPath)
        cell.textLabel?.text = cellData.label
        return cell
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let data = data else {
            fatalError("Application error no cell data available")
        }
        
        let cellData = data[indexPath.row]
        guard let color = cellData.color else {
            cell.textLabel?.textColor = UIColor.black
            cell.backgroundColor = UIColor.white
            return
        }
        
        var red = CGFloat(0.0), green = CGFloat(0.0), blue = CGFloat(0.0), alpha = CGFloat(0.0)
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let threshold = CGFloat(105)
        let bgDelta = ((red * 0.299) + (green * 0.587) + (blue * 0.114));
        
        let textColor = (255 - bgDelta < threshold) ? UIColor.black : UIColor.white;
        cell.textLabel?.textColor = textColor
        cell.backgroundColor = color
    }
}
