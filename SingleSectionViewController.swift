//
//  SingleSectionViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/26.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

class SingleSectionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var ctrlnames: [String]?
    var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Initialize data from "Controls.plist"
        self.ctrlnames = NSArray(contentsOfFile: Bundle.main.path(forResource: "Controls", ofType: "plist")!) as? Array
        
        print(self.ctrlnames ?? "nil")
        
        self.tableView = UITableView(frame: self.view.frame, style: .plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        
        self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "SingleSectionCell")
        
        self.view.addSubview(self.tableView!)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.ctrlnames!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "SingleSectionCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)

        cell.textLabel?.text = self.ctrlnames![indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let index = indexPath.row
        self.ctrlnames?.remove(at: index)
        self.tableView?.deleteRows(at: [indexPath], with: .top)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }

    

}
