//
//  ViewController.swift
//  Todoey
//
//  Created by Davide Santo on 02.06.19.
//  Copyright © 2019 Davide Santo. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    
    var realm = try! Realm()
    var todoItems : Results<Item>?
    
    var selectedCategory : Category? { didSet{    // if the Category is SET then automatically call loadItem()
           loadItems()
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //loadItems()
        
    }
 // MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            // Ternary operator ⇒ Value = condition ? valueifTrue : value ifFalse
            cell.accessoryType =  item.done ? .checkmark : .none
            
        } else {
            cell.textLabel?.text = "No item added"
        }
        
        return cell
    }
    
    // MARK - Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
 //                   realm.delete(item)
                   item.done = !item.done
                }
            } catch {
                print("Errors saving done status , \(error)")
            }
            tableView.reloadData()
        }
        
      
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let  alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
        //CLosure: what will happen when user klick the ADD Item Button of UIAlert
            
        // Save into Real DB the freshly newly created Items associated to the selected category
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Failed saving new Item , \(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion:nil)
    }
    

    func loadItems() {
        // Here we load based on the selected Category the items (into todoItems Optional). The loading is sorted by Ascending Alphabetical order
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
}

// MARK - SearchBar Methods implemented as Extension

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {  // dismiss the searchbar
            loadItems()
            // Running the method on the MAin Queue
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}
