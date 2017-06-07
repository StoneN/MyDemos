//
//  ToDoViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/31.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit
import os.log

class ToDoViewController: UIViewController, UITextFieldDelegate {
    
    var todo: ToDoItem?
    
    @IBOutlet weak var childButton: UIButton!
    @IBOutlet weak var phoneButton: UIButton!
    @IBOutlet weak var shoppingCartButton: UIButton!
    @IBOutlet weak var travelButton: UIButton!

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        childButton.isSelected = true
        textField.delegate = self
        
        if let todo = todo {
            navigationItem.title = todo.title
            textField.text = todo.title
            datePicker.date = todo.date
            
            if todo.image != "child-selected" {
                resetButtons()
                if todo.image == "phone-selected" {
                    phoneButton.isSelected = true
                } else if todo.image == "shopping-cart-selected" {
                    shoppingCartButton.isSelected = true
                } else if todo.image == "travel-selected" {
                    travelButton.isSelected = true
                }
            }
        }
        highlightButton()
        updateSaveButtonState()
    }
    
    func resetButtons() {
        childButton.isSelected = false
        phoneButton.isSelected = false
        shoppingCartButton.isSelected = false
        travelButton.isSelected = false
    }
    
    func highlightButton() {
        childButton.setImage(nil, for: .normal)
        phoneButton.setImage(nil, for: .normal)
        shoppingCartButton.setImage(nil, for: .normal)
        travelButton.setImage(nil, for: .normal)
        
        if childButton.isSelected {
            childButton.setImage(UIImage(named: "child-selected"), for: .normal)
        } else if phoneButton.isSelected {
            phoneButton.setImage(UIImage(named: "phone-selected"), for: .normal)
        } else if shoppingCartButton.isSelected {
            shoppingCartButton.setImage(UIImage(named: "shopping-cart-selected"), for: .normal)
        } else if travelButton.isSelected {
            travelButton.setImage(UIImage(named: "travel-selected"), for: .normal)
        }
    }

    //MARK: Private Methods
    private func updateSaveButtonState() {
        let text = textField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    
    
    // MARK: - Actions
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPressentingInAddMealMode = presentingViewController is UINavigationController
        
        if isPressentingInAddMealMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The MealViewController is not inside a navigation controller.")
        }
    }
    
    @IBAction func childButtonSelected(_ sender: UIButton) {
        resetButtons()
        childButton.isSelected = true
        highlightButton()
    }
    
    @IBAction func phoneButtonSelected(_ sender: UIButton) {
        resetButtons()
        phoneButton.isSelected = true
        highlightButton()
    }

    @IBAction func shoppingCartButtonSelected(_ sender: UIButton) {
        resetButtons()
        shoppingCartButton.isSelected = true
        highlightButton()
    }
    
    @IBAction func travelButtonSelected(_ sender: UIButton) {
        resetButtons()
        travelButton.isSelected = true
        highlightButton()
    }
    
    
    //MARK: UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        saveButton.isEnabled = false
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        let title = textField.text ?? ""
        let date = datePicker.date
        var image = ""
        if childButton.isSelected {
            image = "child-selected"
        } else if phoneButton.isSelected {
            image = "phone-selected"
        } else if shoppingCartButton.isSelected {
            image = "shopping-cart-selected"
        } else if travelButton.isSelected {
            image = "travel-selected"
        }
        
        let uuid = UUID().uuidString
        todo = ToDoItem(id: uuid, image: image, title: title, date: date)
    }

}
