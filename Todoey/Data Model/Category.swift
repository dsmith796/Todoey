//
//  Category.swift
//  Todoey
//
//  Created by Dannielle Smith on 20/07/2018.
//  Copyright © 2018 Dannielle Smith. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object {
    
    @objc dynamic var name : String = ""
    @objc dynamic var colour : String = ""
    @objc dynamic var dateAdded : Date?
    
    let items = List<Item>()
    
}
