//
//  AlertController.swift
//  SimpleToDoList
//
//  Created by Marat on 28.03.2021.
//

import UIKit

class AlertController: UIAlertController {
    
    func action(_ task: Task?, completion: @escaping (String) -> Void) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newValue = self.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }
        
        let canselAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        addAction(saveAction)
        addAction(canselAction)
        addTextField { textField in
            textField.text = task?.name
            textField.placeholder = "Task"
        }
    }
}
