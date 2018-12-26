//
//  Item.swift
//  Todoey
//
//  Created by Maks Maxx on 26/12/2018.
//  Copyright © 2018 Maks Maxx. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
