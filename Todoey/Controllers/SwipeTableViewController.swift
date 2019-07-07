//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Davide Santo on 23.06.19.
//  Copyright © 2019 Davide Santo. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
         tableView.rowHeight = 65.0

    }
    
    // Table View Data source method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell        
        cell.delegate = self
        
        return cell
    }

    // Manage a Delete Button
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            print("Deteled Cell")
            self.updateModel(at: indexPath)  // call top local updateModel function for selected Cell
            
        
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
    }
    // Manage Expansion and Transition of Swipe
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .drag
        return options
    }
    // THis function is a placeholder to be overridden in final TableView Class to Upate Model
    func updateModel(at indexPath: IndexPath) {
        //Update Data Model
        print("Item deleted via SuperClass")
    }
    
}
