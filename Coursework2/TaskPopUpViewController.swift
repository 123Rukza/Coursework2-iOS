//
//  TaskPopUpViewController.swift
//  Coursework2
//
//  Created by Rukshan Hassim on 5/25/19.
//  Copyright © 2019 Rukshan Hassim. All rights reserved.
//

import UIKit
import CoreData

class TaskPopUpViewController: UIViewController {
    
    @IBOutlet var txtTaskName: UITextView!
    @IBOutlet weak var txtTaskNotes: UITextField!
    @IBOutlet weak var selStartDate: UIDatePicker!
    @IBOutlet weak var selDueDate: UIDatePicker!
    @IBOutlet weak var swiDelayAlert: UISwitch!
    @IBOutlet weak var txtCompletion: UITextField!
    
    var selectedProject: SelectedProject?
    var isUpdate: Bool?
    var updateTask: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isUpdate ?? false {
            txtTaskName.text = updateTask?.value(forKey: "name") as? String
            txtTaskNotes.text = updateTask?.value(forKey: "notes") as? String
            selStartDate.date = (updateTask?.value(forKey: "start") as? Date)!
            selDueDate.date = (updateTask?.value(forKey: "end") as? Date)!
            swiDelayAlert.isOn = (updateTask?.value(forKey: "alert") as? Bool)!
            txtCompletion.text! = String(updateTask?.value(forKey: "percentage") as! Int)
        }
    }
    
    @IBAction func btnSave(_ sender: Any) {
        let name = txtTaskName.text!
        let notes = txtTaskNotes.text!
        let start = selStartDate.date
        let end = selDueDate.date
        let alert = swiDelayAlert.isOn
        let percentage = txtCompletion.text!
        let project = selectedProject!.getSelectedProject()
        
        let val = Int(percentage) ?? 0
        
        var alertMessage = "Successfully added task " + name
        
        do {
            if isUpdate ?? false {
                updateTask?.setValue(name, forKey: "name")
                updateTask?.setValue(notes, forKey: "notes")
                updateTask?.setValue(start, forKey: "start")
                updateTask?.setValue(end, forKey: "end")
                updateTask?.setValue(alert, forKey: "alert")
                updateTask?.setValue(val, forKey: "percentage")
                updateTask?.setValue(project, forKey: "master")
                
                try updateTask?.managedObjectContext?.save()
            } else {
                // connect to app delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                // create DB context
                let context = appDelegate.persistentContainer.viewContext
                
                // create new records
                let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: context)
                
                task.setValue(name, forKey: "name")
                task.setValue(notes, forKey: "notes")
                task.setValue(start, forKey: "start")
                task.setValue(end, forKey: "end")
                task.setValue(alert, forKey: "alert")
                task.setValue(val, forKey: "percentage")
                task.setValue(project, forKey: "master")
                
                try context.save()
            }
        } catch let error as NSError {
            alertMessage = "An error has occured while saving. Please restart the application and try again. Error info: " + error.localizedDescription
        }
        
        let alertM = UIAlertController(title: "Saving Status", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alertM.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: { ACTION in
            self.btnCancel(UIButton())
        }))
        self.present(alertM, animated: true, completion: nil)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
