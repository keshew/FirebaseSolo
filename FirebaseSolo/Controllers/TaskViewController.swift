//
//  TaskViewController.swift
//  FirebaseSolo
//
//  Created by Артём Коротков on 07.09.2022.
//

import UIKit
import Firebase

class TaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlets
    
    @IBOutlet weak var tablevViewOutlet: UITableView!
    
    
    
    
    //MARK: - var/let
    
    var user: User!
    var ref: Firebase.DatabaseReference!
    var tasks = Array<Task>()
    
    
    //MARK: - Ovveride
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let currentUser = FirebaseAuth.Auth.auth().currentUser else {return}
        user = User(user: currentUser)
        ref = Firebase.Database.database().reference(withPath: "users").child(String(user.uid)).child("tasks")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value) { [ weak self ](snapshot) in
            var _tasks = Array<Task>()
            for item in snapshot.children {
                    let task = Task(snapshot: item as! Firebase.DataSnapshot)
                _tasks.append(task)
            }
            self?.tasks = _tasks
            self?.tablevViewOutlet.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ref.removeAllObservers()
    }
    //MARK: - MainCode
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = tasks[indexPath.row]
        let taksTitle = task.title
        let isCompleted = task.isCompleted
        cell.textLabel?.text = taksTitle
        toggleCompletion(cell, isCompleted: isCompleted)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            task.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tablevViewOutlet.cellForRow(at: indexPath) else { return }
        let task = tasks[indexPath.row]
        let isCompleted = !task.isCompleted
        toggleCompletion(cell, isCompleted: isCompleted)
        task.ref?.updateChildValues(["isCompleted": isCompleted])
    }

    func toggleCompletion(_ cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = isCompleted ? .checkmark : .none
    }
    //MARK: - IBActions
        
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "New task", message: "Add new task", preferredStyle: .alert)
        alertController.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
            
            guard let textfield = alertController.textFields?.first, textfield.text != "" else {return}
            let task = Task(title: textfield.text!, userID: (self?.user.uid)!)
            let taskRef = self?.ref.child(task.title.lowercased())
            taskRef?.setValue(task.convertToDic())
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive)
        alertController.addAction(cancel)
        alertController.addAction(save)
        present(alertController, animated: true)
        
    }
    
    
    
    
    
 
    @IBAction func signOut(_ sender: UIBarButtonItem) {
        do {
           try FirebaseAuth.Auth.auth().signOut()
        } catch {
            print(error)
        }
        dismiss(animated: true)
}








}
