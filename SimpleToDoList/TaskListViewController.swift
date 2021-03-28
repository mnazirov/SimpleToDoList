//
//  ViewController.swift
//  SimpleToDoList
//
//  Created by Marat on 18.03.2021.
//

import UIKit

enum Action {
    case add
    case edit
}

class TaskListViewController: UITableViewController {
    
    private let storageManager = StorageManager.shared
    private let cellID = "cell"
    private var tasks = StorageManager.shared.fetchData()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setNavigavionBar()
    }
    
    private func setNavigavionBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // создаем экземпляр класса для кастомизации NavigavionBar
        let navigationBarAppearance = UINavigationBarAppearance()
        
        // изменяем цвет заголовка
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // изменяем цвет фона
        navigationBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        // передаем наш кастомный Navigation Bar
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        
        // Добавление кнопки добавления
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask() {
        showAlert()
    }

    
    private func showAlert(_ task: Task? = nil, completion: (() -> Void)? = nil) {
        let title = task != nil ? "Add task" : "Updata task"
        
        let alert = AlertController(
            title: title,
            message: "What do you do?",
            preferredStyle: .alert
        )
        
        alert.action(task) { newValue in
            if let task = task, let completion = completion {
                self.storageManager.edit(newValue, task)
                completion()
            } else {
                self.storageManager.save(newValue) { task in
                    print("Save")
                    self.tasks.append(task)
                    self.tableView.insertRows(
                        at: [IndexPath(row: self.tasks.count - 1, section: 0)],
                        with: .automatic)
                }
            }
        }
        
        present(alert, animated: true)
    }
}

// MARK: - TableView DataSource
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = tasks[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = task.name
        
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            storageManager.delete(tasks[indexPath.row])
            tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showAlert(tasks[indexPath.row]) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
