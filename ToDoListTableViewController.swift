//
//  ToDoListTableViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/31.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit
import os.log

class ToDoListTableViewController: UITableViewController {

    var todos: [ToDoItem] = []
    
    @IBOutlet weak var todoTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        loadSampleTodos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todoTableView.reloadData()
    }
    

    private func loadSampleTodos() {
        todos = [ToDoItem(id: "1", image: "child-selected", title: "Go to Disney", date:dateFromString("2017-03-03")!),
                 
                 ToDoItem(id: "2", image: "phone-selected", title: "Phone to Jobs", date: dateFromString("2017-03-04")!),
                 
                 ToDoItem(id: "3", image: "shopping-cart-selected", title: "Cicso Shopping", date: dateFromString("2017-03-04")!),
                 
                 ToDoItem(id: "4", image: "travel-selected", title: "Plan to Europe", date: dateFromString("2017-03-05")!),]
    }
    
    private func noDataMessage(messageLabel: UILabel) {
        setMessageLabel(messageLabel, frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height), text: "No data is currently avalible.", textColor: UIColor.black, numberOfLines: 0, textAlignment: NSTextAlignment.center, font: UIFont(name: "Palatino- Italic", size: 20)!)
        self.todoTableView.backgroundView = messageLabel
        self.todoTableView.separatorStyle = UITableViewCellSeparatorStyle.none
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let messageLabel = UILabel()
        if todos.count == 0 {
            noDataMessage(messageLabel: messageLabel)
            return 0
        } else {
            self.todoTableView.backgroundView = nil
            return todos.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "todoTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        let todo = todos[indexPath.row]
        cell.textLabel?.text = todo.title
        cell.detailTextLabel?.text = stringFromDate(todo.date)
        cell.imageView?.image = UIImage(named: todo.image)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return self.isEditing
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let todo = todos.remove(at: fromIndexPath.row)
        todos.insert(todo, at: to.row)
    }
    
    
    //MARK: Actions
    @IBAction func unwindToTodoList(sender: UIStoryboardSegue) {
        
        if let sourceViewController = sender.source as? ToDoViewController, let todo = sourceViewController.todo {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                todos[selectedIndexPath.row] = todo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                let newIndexPath = IndexPath(row: todos.count, section: 0)
                todos.append(todo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
    }
    @IBAction func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "AddTodoItem":
            os_log("Adding a new todo.", log: OSLog.default, type: .debug)
        case "ShowTodoDetail":
            guard let todoDetailViewController = segue.destination as? ToDoViewController else {
                fatalError("Unexpected destinction: \(segue.destination)")
            }
            guard let selectedTodoCell = sender as? UITableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedTodoCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedTodo = todos[indexPath.row]
            todoDetailViewController.todo = selectedTodo
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

}
