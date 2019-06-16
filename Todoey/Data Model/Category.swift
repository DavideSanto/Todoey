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
    let items = List<Item>()   // Emply list of Items used by REal to create relationship (this defines the forward relationship such that a Category points to a list of Items
    
}
