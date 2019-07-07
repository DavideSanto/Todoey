//
//  Category.swift
//  Todoey
//
//  Created by Davide Santo on 16.06.19.
//  Copyright © 2019 Davide Santo. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    let items = List<Item>()   // Empty list of Items used by Realm to create relationship (this defines the forward relationship such that a Category points to a list of Items
    
}
