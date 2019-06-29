//
//  CategoriesViewController.swift
//  Documents Core Data Relationships
//
//  Created by Felipe Costa on 6/28/19.
//  Copyright © 2019 Felipe Costa. All rights reserved.
//

import UIKit
import CoreData

class CategoriesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var categoriesTableView: UITableView!
    
    var categories = [Category]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Categories"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCategories(searchString: "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func AddCategory(_ sender: Any) {
        let alert = UIAlertController(title: "Add New Category", message: "Please enter a new category", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: {
            (alertAction) -> Void in
            if let textField = alert.textFields?[0], let name = textField.text {
                let categoryName = name.trimmingCharacters(in: .whitespaces)
                if (categoryName == "") {
                    let error = UIAlertController(title: "Alert", message: "Category not created.\nThe name must contain a value.", preferredStyle: UIAlertController.Style.alert)
                    error.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(error, animated: true, completion: nil)
                    return
                }
                self.addToCoreData(name: categoryName)
            } else {
                let error = UIAlertController(title: "Alert", message: "Category not created.\nThe name is not accessible.", preferredStyle: UIAlertController.Style.alert)
                error.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(error, animated: true, completion: nil)
                return
            }
            
        }))
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "category name"
            textField.isSecureTextEntry = false
            
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    func addToCoreData(name: String){
        if (categoryExists(name: name)) {
            let error = UIAlertController(title: "Alert", message: "Category \(name) already exists.", preferredStyle: UIAlertController.Style.alert)
            error.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(error, animated: true, completion: nil)
            return
        }
        
        let category = Category(name: name)
        
        if let category = category {
            do {
                let managedObjectContext = category.managedObjectContext
                try managedObjectContext?.save()
            } catch {
                print("Category could not be saved.")
            }
        } else {
            print("Category could not be created.")
        }
        
        fetchCategories(searchString: "")

    }
    
    func categoryExists(name: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, name != "" else {
            return false
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            fetchRequest.predicate = NSPredicate(format: "name == %@", name)
            let results = try managedContext.fetch(fetchRequest)
            if results.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    func fetchCategories(searchString: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        do {
            if (searchString != "") {
                fetchRequest.predicate = NSPredicate(format: "name contains[c] %@", searchString)
            }
            categories = try managedContext.fetch(fetchRequest)
            categoriesTableView.reloadData()
        } catch {
            print("Fetch could not be performed")
        }
    }
    
    func confirmDeleteCategory(at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        
        if let documentSet = category.rawDocument, documentSet.count > 0 {
            // confirm deletion
            let name = category.name ?? "Category"
            let alert = UIAlertController(title: "Delete Category", message: "\(name) contains documents. Do you want to delete it?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: {
                (alertAction) -> Void in
                // handle cancellation of deletion
                self.categoriesTableView.reloadData()
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.destructive, handler: {
                (alertAction) -> Void in
                // handle deletion here
                self.deleteCategory(at: indexPath)
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            deleteCategory(at: indexPath)
        }
    }
    
    
    func deleteCategory(at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        
        if let managedObjectContext = category.managedObjectContext {
            managedObjectContext.delete(category)
            
            do {
                try managedObjectContext.save()
                self.categories.remove(at: indexPath.row)
                categoriesTableView.deleteRows(at: [indexPath], with: .automatic)
            } catch {
                print("Delete failed: \(error).")
                categoriesTableView.reloadData()
            }
        }
    }
    
    func updateCategory(at indexPath: IndexPath, name: String) {
        let category = categories[indexPath.row]
        category.name = name
        
        if let managedObjectContext = category.managedObjectContext {
            do {
                try managedObjectContext.save()
                fetchCategories(searchString: "")
            } catch {
                print("Update failed.")
                categoriesTableView.reloadData()
            }
        }
    }
    
    func edit(at indexPath: IndexPath) {
        let category = categories[indexPath.row]
        let alert = UIAlertController(title: "Edit Category", message: "Enter new category name.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Submit", style: UIAlertAction.Style.default, handler: {
            (alertAction) -> Void in
            if let textField = alert.textFields?[0], let name = textField.text {
                let categoryName = name.trimmingCharacters(in: .whitespaces)
                if (categoryName == "") {
                    let alert = UIAlertController(title: "Alert", message: "Category name not changed.\nA name is required.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                if (categoryName == category.name) {
                    // Nothing to change, new name is old name.
                    // Do this check before checking that categoryExists,
                    // otherwise if category name doesn't change error about already existing will occur.
                    return
                }
                
                if (self.categoryExists(name: categoryName)) {
                    
                    let alert = UIAlertController(title: "Alert", message: "Category name not changed.\n\(categoryName) already exists.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
                self.updateCategory(at: indexPath, name: categoryName)
            } else {
                let alert = UIAlertController(title: "Alert", message: "Category name not changed.\nThe name is not accessible.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
        }))
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "category name"
            textField.isSecureTextEntry = false
            textField.text = category.name?.uppercased()
            
        })
        self.present(alert, animated: true, completion: nil)
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let category = categories[indexPath.row]
        cell.textLabel?.text = category.name?.uppercased()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") {
            action, index in
            self.confirmDeleteCategory(at: indexPath)
        }
        
        let edit = UITableViewRowAction(style: .default, title: "Edit") {
            action, index in
            self.edit(at: indexPath)
        }
        edit.backgroundColor = UIColor.blue
        
        return [delete, edit]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0;//Choose your custom row height
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DocumentsViewController,
            let row = categoriesTableView.indexPathForSelectedRow?.row {
            destination.category = categories[row]
        }
    }

}
