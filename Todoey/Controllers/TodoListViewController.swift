//
//  ViewController.swift
//  Todoey
//
//  Created by Davide Santo on 02.06.19.
//  Copyright © 2019 Davide Santo. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory : Category? { didSet{    // as the Category is SET then automatically call loadItem()
            loadItems()
        }
        
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //loadItems()
        
    }
 // MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Ternary operator ⇒
        // Value = condition ? valueifTrue : value ifFalse
        cell.accessoryType =  item.done ? .checkmark : .none
        
        return cell
    }
    
    // MARK - Tableview delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        
        itemArray[indexPath.row].done = !(itemArray[indexPath.row].done)
        
        //to Delete/remove an item from Core Data DB first Delete from Context then Remopve from the Array used to display on TableView
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        saveItems()
      
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let  alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //CLosure: what will happen when user klick the ADD Item Button on UIAlert
            
            let newItem = Item(context: self.context)  //Create new Item in the Persistent Database (SQLIte DB under Core Data)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            self.saveItems()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion:nil)
    }
    
    // Save items  in Application Folder
    func saveItems() {
        
        do{
           try context.save()
        } catch {
            print("Error while saving context \(error)")
        }
        tableView.reloadData()
    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        // To load properly we need to 'sort' according to the category chosen and then combine with general Predicate usually
        // set to ni passed via the parameters of the loadItems function
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        //Associate to the request the queary predicate
  
        if let additionalPredicate = predicate {   // if predicate is not nil (so USer is doing a Search)
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate  // in case predciate is nil...default case
        }
        
//        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates:  [categoryPredicate,predicate])
//        request.predicate = compoundPredicate
        
        do {
            itemArray = try context.fetch(request)   // Now we Fetch based on the Category Chosen
        } catch {
            print("Error while uploading \(error) ")
        }
        tableView.reloadData()
    }
    
    
}

// MARK - SearchBar Methods

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // to read from a Context ALWAYS create a Request with explicit TYPE indicated <xxx>
        let request : NSFetchRequest<Item> = Item.fetchRequest()  // This the the Request to Fetch from teh Database cal;led 'Item'
        // let's create a filter for SearchBar using a 'Predicate' (look at https://academy.realm.io/posts/nspredicate-cheatsheet/)
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)  // [cd] means to ignore Case and Diacritics
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
        }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            // Running the method on the MAin Queue
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}
