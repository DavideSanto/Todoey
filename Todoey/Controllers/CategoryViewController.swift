//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Davide Santo on 09.06.19.
//  Copyright © 2019 Davide Santo. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadCategories()
       }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    // Function to populate the Category TableView (IN: local TableView and Cell Selected, OUT: Table View Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Let's grab a cell from the Queue 
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
    }
    
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()   // textfiled inside the Alert where the USER will add the name of the Category to be created
        
        let  alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            //CLosure: what will happen when user klick the ADD Item Button on UIAlert
            
            let newCategory = Category()  //Create new Category in the  Database (SQLIte DB under Core Data)
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
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error while saving Category  \(error)")
        }
        tableView.reloadData()  // TableView is refreshed
    }
    
    func loadCategories() {
//
//        let request: NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("Error while Up-loading Categories \(error) ")
//        }
         categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - TableView Delegate Methods (or what happens when User clocks on a Category in teh TableView list
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
