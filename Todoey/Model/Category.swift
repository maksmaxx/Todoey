//
//  Category.swift
//  Todoey
//
//  Created by Maks Maxx on 26/12/2018.
//  Copyright © 2018 Maks Maxx. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    

}
