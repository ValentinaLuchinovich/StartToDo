//
//  TaskViewController.swift
//  StartToDo
//
//  Created by Валентина Лучинович on 24.12.2021.
//

import UIKit
import Firebase

class TaskViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
        // Реализация добавления задач через Alert Controller
        let alertController = UIAlertController(title: "Новая задача", message: "Добавить новую задачу", preferredStyle: .alert)
        alertController.addTextField()
        let save = UIAlertAction(title: "Соxранить", style: .default) { _ in
            guard let textField = alertController.textFields?.first, textField.text != "" else { return }
            
            ////
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.backgroundColor = .clear
        var content = cell.defaultContentConfiguration()
        content.text = "Это ячейка номер \(indexPath.row)"
        content.textProperties.color = .white
        cell.contentConfiguration = content
        return cell
    }
    
    
    
}
