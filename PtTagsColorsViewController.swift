//
//  PtTagsColorsViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/6/1.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

class PtTagsColorsViewController: UIViewController {

    // MARK: - Properties
    var tags: [String]?
    var colors: [PtPhotoColor]?
    var tableViewController: PtTagsColorsTableViewController!
    
    // MARK: - IBOutlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DataTable" {
            guard let controller = segue.destination as? PtTagsColorsTableViewController else {
                fatalError("Storyboard mis-configuration. Controller is not of expected type TagsColorTableViewController")
            }
            
            tableViewController = controller
        }
    }
    
    // MARK: - IBActions
    @IBAction func tagsColorsSegmentedControlChanged(_ sender: UISegmentedControl) {
        setupTableData()
    }
    
    
    // MARK: - Public
    func setupTableData() {
        if segmentedControl.selectedSegmentIndex == 0 {
            
            if let tags = tags {
                tableViewController.data = tags.map {
                    TagsColorTableData(label: $0, color: nil)
                }
            } else {
                tableViewController.data = [TagsColorTableData(label: "No tags were fetched.", color: nil)]
            }
        } else {
            if let colors = colors {
                tableViewController.data = colors.map({ (photoColor: PtPhotoColor) -> TagsColorTableData in
                    let uicolor = UIColor(red: CGFloat(photoColor.red!) / 255, green: CGFloat(photoColor.green!) / 255, blue: CGFloat(photoColor.blue!) / 255, alpha: 1.0)
                    return TagsColorTableData(label: photoColor.colorName!, color: uicolor)
                })
            } else {
                tableViewController.data = [TagsColorTableData(label: "No colors were fetched.", color: nil)]
            }
        }
        tableViewController.tableView.reloadData()
    }
}
