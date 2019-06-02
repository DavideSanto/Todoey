//
//  ViewController.swift
//  Todoey
//
//  Created by Davide Santo on 02.06.19.
//  Copyright © 2019 Davide Santo. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy eggs", "Destroy DemoGorgons"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
 // MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    // MARK - Tableview delegate method
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        
        
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
          tableView.cellForRow(at: indexPath)?.accessoryType = .none
            print("removed \(itemArray[indexPath.row]) from To do List ")
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            print(itemArray[indexPath.row])
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let  alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when user klick teh ADD Item Button on UIalert
            
            self.itemArray.append(textField.text!)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion:nil)
    }
    
}

