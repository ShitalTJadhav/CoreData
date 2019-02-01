//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Tushar  Jadhav on 2019-02-01.
//  Copyright © 2019 Shital  Jadhav. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var users: [User] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        title = "The List"
      //  tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        //Fetch users from core data
        fetchUserFromCoreData()
    }

    @IBAction func addNewUser(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New User",
                                      message: "Add a new user name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        
                                        guard let textField = alert.textFields?.first,
                                            let name = textField.text else {
                                                return
                                        }
                                        
                                        guard let passTextField = alert.textFields?[1],
                                            let password = passTextField.text else {
                                                return
                                        }
                                        
                                        guard let ageTextField = alert.textFields?[2],
                                            let age = ageTextField.text else {
                                                return
                                        }
                                        
                                        //Save user into core data
                                        self.saveUsersIntoCoredata(name: name, pass: password, age: age)

        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField { textField in
            textField.placeholder = "Username"
        }
        
        alert.addTextField{ textField in
            textField.placeholder = "Password"
        }
        
        alert.addTextField{ textField in
            textField.placeholder = "Age"
        }

        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
        

    }
    
    fileprivate func saveUsersIntoCoredata(name: String, pass: String, age: String) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //We need to create a context from this container.
        let context = appDelegate.persistentContainer.viewContext
        
        //        Now let’s create an entity and new user records.
        let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        //At last, we need to add some data to our newly created record for each keys using
        newUser.setValue(name, forKey: "username")
        newUser.setValue(pass, forKey: "password")
        newUser.setValue(age, forKey: "age")
        
        //Save the data
        do {
            try context.save()

            //Fetch users from core data
            let user = User(username: name, password: pass, age: age)
            users.append(user)
            tableView.reloadData()
            
        } catch {
            print("Failed saving")
        }
    }
    
    fileprivate func fetchUserFromCoreData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //We need to create a context from this container.
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Users")
        //request.predicate = NSPredicate(format: "age = %@", "12")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
//                print(data.value(forKey: "username") as! String)
                let username = data.value(forKey: "username") as! String
                let pass = data.value(forKey: "password") as! String
                let age = data.value(forKey: "age") as! String
                
                let user = User(username: username, password: pass, age: age)
                users.append(user)
            }
            
            tableView.reloadData()

        } catch {
            
            print("Failed")
        }
    }

}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    //let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")

            cell.textLabel?.text = users[indexPath.row].username
            cell.detailTextLabel?.text = "Age : " + users[indexPath.row].age
            return cell
    }
}

