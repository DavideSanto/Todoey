//
//  ViewController.swift
//  Todoey
//
//  Created by Davide Santo on 02.06.19.
//  Copyright © 2019 Davide Santo. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    
    var realm = try! Realm()
    var todoItems : Results<Item>?
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory : Category? { didSet{    // if the Category is SET then automatically call loadItem()
           loadItems()
        }
    

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(" To localize the Realm Object: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))")
        
       
        tableView.separatorStyle = .none
        //loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name
        guard  let colourHex = selectedCategory?.colour else {fatalError("Selected Category Colour does not exist")}
        updateNavBar(withHexCode: colourHex)
        
    }
    // Restablishing the initial Nav bar Colours
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColour = UIColor(hexString: "1D9BF6") else {fatalError("Original Color Hex Code is erroneous")}
        updateNavBar(withHexCode: originalColour.hexValue())
    }
    
    //MARK - Nav Bar Setup methods
    
    func updateNavBar(withHexCode colourHexCode: String) {
       
        guard let navbar = navigationController?.navigationBar else {fatalError("Navigation Controller not yet created")}
        
        
        guard let navBarColour = UIColor(hexString: colourHexCode) else {fatalError("Nav Bar COlour does not return")}
        navbar.barTintColor = navBarColour
        navbar.tintColor = ContrastColorOf(navBarColour, returnFlat: true)
        navbar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navBarColour, returnFlat: true)]
        searchBar.barTintColor = navBarColour
    }
    
 // MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //original code: let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) -- Now in Super Class
    
        // Retrieving the cell object pointed by actual indexPath in actual Table view from SUperClass which dequeue it
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        //Optional Chaining used as we wish to access the property of the todoItems which is an array of optional 'Item' objects
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            if let colour = UIColor(hexString:selectedCategory!.colour)?.darken(byPercentage:CGFloat( indexPath.row) / CGFloat(todoItems!.count)){
                cell.backgroundColor = colour
                cell.textLabel?.textColor = ContrastColorOf(colour, returnFlat: true)
            }
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
               //    realm.delete(item)
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
        //Closure: what will happen when user klick the ADD Item Button of UIAlert
            
        // Save into Realm DB the freshly created Items associated to the currently selected category
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
        
        // This section simply dispaly the Alert/action Window
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion:nil)
    }
    

    func loadItems() {
        // Here we load based on the currently selected Category the items (into todoItems Optional). The loading is sorted by Ascending Alphabetical order
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: Delete Data using SwipeCell implemented in a Super Call we inherited from
    override func updateModel(at indexPath: IndexPath) {
        
        super.updateModel(at: indexPath)
        if let itemForDeletion = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                        self.realm.delete(itemForDeletion)
                }
            } catch {
                print("Error while Deleting Items from Realm, \(error)")
            }
        }
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
