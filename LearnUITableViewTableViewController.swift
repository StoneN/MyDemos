//
//  LearnUITableViewTableViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/26.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

class LearnUITableViewTableViewController: UITableViewController {

    var lessions: [String] = ["SeveralSections", "SingleSection(slide to delete)", "ToDo Demo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.clearsSelectionOnViewWillAppear = true
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "LearnTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        cell.textLabel?.text = lessions[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lession: String = lessions[indexPath.row]
        
        switch lession {
        case "SeveralSections":
            let nextController = self.storyboard?.instantiateViewController(withIdentifier: "SeveralSectionsViewController")
            self.navigationController?.pushViewController(nextController!, animated: true)
        case "SingleSection(slide to delete)":
            let nextController = self.storyboard?.instantiateViewController(withIdentifier: "SingleSectionViewController")
            self.navigationController?.pushViewController(nextController!, animated: true)
        case "ToDo Demo":
            let nextController = self.storyboard?.instantiateViewController(withIdentifier: "ToDoDemo")
            self.navigationController?.pushViewController(nextController!, animated: true)
        default:
            return
        }
    }


}
