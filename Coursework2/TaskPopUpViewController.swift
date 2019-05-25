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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnSave(_ sender: Any) {
        // connect to app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // create DB context
        let context = appDelegate.persistentContainer.viewContext
        
        // create new records
        let task = NSEntityDescription.insertNewObject(forEntityName: "Task", into: context)
        
        let name = txtTaskName.text!
        let notes = txtTaskNotes.text!
        let start = selStartDate.date
        let end = selDueDate.date
        let alert = swiDelayAlert.isOn
        let percentage = txtCompletion.text!
        let project = selectedProject!.getSelectedProject()
        
        var val = 0
        
        do {
            val = Int(percentage)!
        } catch  {
            val = 0
        }
        
        task.setValue(name, forKey: "name")
        task.setValue(notes, forKey: "notes")
        task.setValue(start, forKey: "start")
        task.setValue(end, forKey: "end")
        task.setValue(alert, forKey: "alert")
        task.setValue(val, forKey: "percentage")
        task.setValue(project, forKey: "master")
        
        var alertMessage = "Successfully added task " + name
        
        do {
            try context.save()
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
