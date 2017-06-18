//
//  MasterTableViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/19.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

class MasterTableViewController: UITableViewController, UISearchResultsUpdating, UISearchBarDelegate {

    
    // MARK: Properties
    var demos = [Demo]()
    var filteredDemos = [Demo]()
    let searchController = UISearchController(searchResultsController: nil)
   
    
    
    // MARK: SearchBar funcs
    
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchBar.text!, scope: scope)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredDemos = demos.filter { demo in
            let levelMatch = (scope == "All") || (demo.level == scope)
            return levelMatch && (demo.name.lowercased().contains(searchText.lowercased()) || searchText == "")
        }

        tableView.reloadData()
    }

    func setupSearchController () {
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ["All", "Easy", "Normal", "Hard"]
        searchController.searchBar.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        demos = [
            Demo(name: "Drawing Board", level: "Hard"),
            Demo(name: "Stop Watch", level: "Easy"),
            Demo(name: "Learn UITableView", level: "Easy"),
            Demo(name: "WeiChat TableView", level: "Normal"),
            Demo(name: "Photo Scroll", level: "Normal"),
            Demo(name: "Alamofire Demo(!)", level: "Easy"),
            Demo(name: "Photo Tagger(?)", level: "Hard"),
            Demo(name: "Collection View Demo1", level: "Easy"),
            Demo(name: "Interests", level: "Hard"),
        ]
        setupSearchController()
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
        let scopeIndex = searchController.searchBar.selectedScopeButtonIndex
        let searchOnlyByScope: Bool =
            searchController.searchBar.text == "" && scopeIndex != 0
        
        if searchController.isActive && (searchController.searchBar.text != "" || searchOnlyByScope) {
            return filteredDemos.count
        }
        return demos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DemoCell", for: indexPath)
        let demo: Demo
        
        let scopeIndex = searchController.searchBar.selectedScopeButtonIndex
        let searchOnlyByScope: Bool =
            searchController.searchBar.text == "" && scopeIndex != 0
        
        if searchController.isActive && (searchController.searchBar.text != "" || searchOnlyByScope) {
            demo = filteredDemos[indexPath.row]
        } else {
            demo = demos[indexPath.row]
        }
        
        cell.textLabel!.text = demo.name
        cell.detailTextLabel!.text = demo.level
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let demo: Demo
        if searchController.isActive && searchController.searchBar.text != "" {
            demo = filteredDemos[indexPath.row]
        } else {
            demo = demos[indexPath.row]
        }
        switch demo.name {
        case "Drawing Board":
            let nextController = self.storyboard?.instantiateViewController(withIdentifier: "BoardViewController")
            self.navigationController?.pushViewController(nextController!, animated: true)
        case "Stop Watch":
            let nextController = self.storyboard?.instantiateViewController(withIdentifier: "StopWatchViewController")
            self.navigationController?.pushViewController(nextController!, animated: true)
        case "Learn UITableView":
            let nextController = self.storyboard?.instantiateViewController(withIdentifier: "LearnUITableViewTableViewController")
            self.navigationController?.pushViewController(nextController!, animated: true)
        case "WeiChat TableView":
            let nextController = self.storyboard?.instantiateViewController(withIdentifier: "WeiChatViewController")
            self.navigationController?.pushViewController(nextController!, animated: true)
        case "Photo Scroll":
            let nextController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoScrollCollectionViewController")
            self.navigationController?.pushViewController(nextController!, animated: true)
        case "Alamofire Demo(!)":
            let nextController = self.storyboard?.instantiateViewController(withIdentifier: "AlamofireDemoViewController")
            self.navigationController?.pushViewController(nextController!, animated: true)
        case "Photo Tagger(?)":
            let nextController = self.storyboard?.instantiateViewController(withIdentifier: "PhotoTaggerViewController")
            self.navigationController?.pushViewController(nextController!, animated: true)
        case "Collection View Demo1":
            let nextController = self.storyboard?.instantiateViewController(withIdentifier: "CollectionViewDemo1ViewController")
            self.navigationController?.pushViewController(nextController!, animated: true)
        case "Interests":
            let nextController = self.storyboard?.instantiateViewController(withIdentifier: "InterestsViewController")
            self.navigationController?.pushViewController(nextController!, animated: true)
            
        default:
            return
        }
    }
}
