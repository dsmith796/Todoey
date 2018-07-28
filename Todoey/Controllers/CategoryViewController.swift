//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Dannielle Smith on 20/07/2018.
//  Copyright © 2018 Dannielle Smith. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework
import RLBAlertsPickers

class CategoryViewController: SwipeTableViewController {
    
    let realm = try! Realm()
    
    var categories : Results<Category>?
    
    let colours = ["Red","Orange","Yellow","Sand","Magenta","Sky Blue","Green","Mint","White","Grey","Purple","Watermelon","Lime","Pink","Coffee","Powder Blue"]
    
    let uicolours = [FlatRed(),FlatOrange(),FlatYellow(),FlatSand(),FlatMagenta(),FlatSkyBlue(),FlatGreen(),FlatMint(),FlatWhite(),FlatGray(),FlatPurple(),FlatWatermelon(),FlatLime(),FlatPink(),FlatCoffee(),FlatPowderBlue()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
        
        tableView.separatorStyle = .none
        navigationController?.navigationBar.tintColor = ContrastColorOf((navigationController?.navigationBar.barTintColor)!, returnFlat: true)
        
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let newCategory = Category()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            newCategory.name = textField.text!
            newCategory.dateAdded = Date()
            self.save(category: newCategory)
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "New Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        let pickerViewValues = [colours]
        let pickerViewSelectedValue : PickerViewViewController.Index = (column : 0, row : colours.index(of: "Red") ?? 0)
        
        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { (vc, picker, index, value) in
            
            newCategory.colour = self.uicolours[index.row].hexValue()
            
        }
        
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            
            cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
            
            let categoryColour = UIColor(hexString: category.colour)
            
            cell.backgroundColor = categoryColour
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
            
        }
        
        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
    //MARK: - Data Manipulation Methods
    func save(category : Category){
        
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        categories = realm.objects(Category.self).sorted(byKeyPath: "dateAdded", ascending: true)
        
        tableView.reloadData()
        
    }
    
    //MARK: - Delete Data From Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        
        if let categoryForDeletion = self.categories?[indexPath.row] {
            
            do {
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            }
            catch {
                print("Error deleting category, \(error)")
            }
        }
        
    }
    
    
}

