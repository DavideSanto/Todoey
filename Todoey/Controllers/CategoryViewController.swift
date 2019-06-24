//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Davide Santo on 09.06.19.
//  Copyright © 2019 Davide Santo. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //First time loading into the view
        loadCategories()
        
      
       }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    

    
    // Function to populate the Category TableView (IN: local TableView and Cell Selected, OUT: Table View Cell updated
    // This works by inheritance of the Super Class SwipeCellTableView [Note here no deleagte functions are used]
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // We are using a Super Class to create Swipe Cells...so we pass the local Table view object and Index Path to the 'Super' Class to manage the delegation for Swiping and we get a constant to write the local cell of this view
        let cell = super.tableView(tableView, cellForRowAt: indexPath)  // this is a Swipe Cell
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
    }
    
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()   // textfiled inside the Alert where the USER will add the name of the Category to be created
        
        let  alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            //CLosure: what will happen when user klick the ADD Item Button on UIAlert
            let newCategory = Category()  //Create new Category in the  Database (This time a REAL DB)
            newCategory.name = textField.text!
            
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion:nil)
    }
    
    //MARK: - Data Manipulation Methods
    
    // Save items  in Application Folder
    func save(category: Category) {
        // Commits to DB the Categories Context created/modified by user
        do{
            try realm.write {          //
                realm.add(category)   // here we add a Realm unmanaged Object inside a Write Context
            }
        } catch {
            print("Error while saving Category  \(error)")
        }
        tableView.reloadData()  // TableView is refreshed
    }
    
    func loadCategories() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    //MARK: Delete Data using SwipeCell implemented in a Super Call we inherited from
    override func updateModel(at indexPath: IndexPath) {
       
        super.updateModel(at: indexPath)
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error while Deleting Categories from Realm, \(error)")
            }
        }
    }
    
    //MARK: - TableView Delegate Methods (or what happens when User clicks on a Category in the TableView list
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    // Function used for Preparing for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController  //Cteate local pointer to Destination View Contrl

        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]  // Pass to DestinationVC the category selected by the user
        }
    
    }
}

