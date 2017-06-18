//
//  SeveralSectionsViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/25.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

class SeveralSectionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView?
    
    var allNames: Dictionary<Int, [String]>?
    
    var adHeaders: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.allNames = [
            0: [String]([
                "UILabel",
                "UITextField",
                "UIButton"]),
            1: [String]([
                "UIDatePicker",
                "UIToolbar",
                "UITableView"])
        ]
        
        self.adHeaders = [
            "Common UIKit Controls",
            "Advanced UIKit Controls"
        ]
        
        self.tableView = UITableView(frame: self.view.frame, style: .grouped)
        
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "SeveralSectionsCell")
        self.view.addSubview(self.tableView!)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let data = self.allNames?[section]
        return data!.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.adHeaders?[section]
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        let data = self.allNames?[section]
        return "\(data!.count) Controls"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "SeveralSectionsCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        cell.accessoryType = .disclosureIndicator
        
        var data = self.allNames?[indexPath.section]
        cell.textLabel?.text = data![indexPath.row]
        
        return cell
    }

    

}
