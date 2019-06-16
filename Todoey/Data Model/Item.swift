//
//  Item.swift
//  Todoey
//
//  Created by Davide Santo on 16.06.19.
//  Copyright © 2019 Davide Santo. All rights reserved.
//

import Foundation
import RealmSwift


class Item: Object {
    
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")  //an auto updating object that is used to define the inverse relationship  where each each item points to a parentCategory
}
