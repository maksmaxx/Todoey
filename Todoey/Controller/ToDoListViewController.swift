//
//  ViewController.swift
//  Todoey
//
//  Created by Maks Maxx on 25/12/2018.
//  Copyright © 2018 Maks Maxx. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    
    //MARK: - Tableview Datasource methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
          itemArray[indexPath.row].done = !itemArray[indexPath.row].done
      
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
//
        saveItems()

        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Adding New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController.init(title: "Add New Todoey item now", message: "", preferredStyle: .alert)
        let action = UIAlertAction.init(title: "Add item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title =  textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            self.saveItems()
            
        }
        
        alert.addTextField(configurationHandler: { (alerttextField) in
            alerttextField.placeholder = "Create new item"
            textField = alerttextField
        })
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        
        do {
            try context.save()
        }
        catch {
            print(error)
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {

        let catpredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
     
        if let  addPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catpredicate, addPredicate])
        } else {
            request.predicate = catpredicate
        }
        
        do{
           itemArray =  try context.fetch(request)
        }
        catch {
            print(error)
        }
        
        tableView.reloadData()
    }
    
    
}

extension ToDoListViewController: UISearchBarDelegate {
  
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
   
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
       
        loadItems(with: request, predicate: predicate)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }

}
