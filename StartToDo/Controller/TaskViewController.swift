//
//  TaskViewController.swift
//  StartToDo
//
//  Created by Валентина Лучинович on 24.12.2021.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func addTapped(_ sender: UIBarButtonItem) {
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
