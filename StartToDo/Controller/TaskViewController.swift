//
//  TaskViewController.swift
//  StartToDo
//
//  Created by Валентина Лучинович on 24.12.2021.
//

import UIKit
import Firebase

class TaskViewController: UIViewController {
    
    var person: Person!
    var ref: DatabaseReference!
    var tasks = [Task]()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let currentUser  = Auth.auth().currentUser else { return }
        person = Person(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(person.uid).child("tasks")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Создаем наблюдателя для чтения и отображенния данных
        ref.observeSingleEvent(of: .value) { [weak self] snapshot in
            var _tasks = [Task]()
            for item in snapshot.children {
                let task = Task(snapshot: item as! DataSnapshot)
                _tasks.append(task)
            }
            self?.tasks = _tasks
            self?.tableView.reloadData()
        }
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        // Реализация добавления задач через Alert Controller
        let alertController = UIAlertController(title: "Новая задача", message: "Добавить новую задачу", preferredStyle: .alert)
        alertController.addTextField()
        let save = UIAlertAction(title: "Соxранить", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first, textField.text != "" else { return }
            // Создаем данные
            let task = Task(title: textField.text ?? "", userID: self?.person.uid ?? "")
            // Создаем конкретную задачу
            let taskRef = self?.ref.child(task.title.lowercased())
            taskRef?.setValue(task.convertDictionary())
        }
        
        let cancel = UIAlertAction(title: "Отменить", style: .default, handler: nil)
        alertController.addAction(save)
        alertController.addAction(cancel)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        // Выходим из профиля
        do {
            try Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        // Закрываем экран
        dismiss(animated: true, completion: nil)
    }
    
}

extension TaskViewController: UITableViewDelegate, UITableViewDataSource {
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        let task = tasks[indexPath.row]
        let taskTitle = task.title
        let isCompleted = task.completed
        cell.textLabel?.text = taskTitle
        toggleCompletion(cell, isCompleted: isCompleted)
        
        return cell
    }
    
    // Базовый функционал для удаления задач
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Метод добавляет кнопку удаления
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let task = tasks[indexPath.row]
            task.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        let task = tasks[indexPath.row]
        let isCompleted = !task.completed
        
        toggleCompletion(cell, isCompleted: isCompleted)
        task.ref?.updateChildValues(["completed": isCompleted])
    }
    
    // Создаем галочку для выполнения задачи
    func toggleCompletion(_ cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = isCompleted ? .checkmark : .none
    }
}
