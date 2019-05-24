//
//  ProjectPopupViewController.swift
//  Coursework2
//
//  Created by Rukshan Hassim on 5/24/19.
//  Copyright © 2019 Rukshan Hassim. All rights reserved.
//

import UIKit
import CoreData

class ProjectPopupViewController: UIViewController {

    @IBOutlet weak var txtProjectName: UITextField!
    @IBOutlet weak var segProjectPriority: UISegmentedControl!
    @IBOutlet weak var selDueDate: UIDatePicker!
    @IBOutlet weak var txtNotes: UITextView!
    @IBOutlet weak var swiAddCalendar: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnSave(_ sender: Any) {
        // connect to app delegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // create DB context
        let context = appDelegate.persistentContainer.viewContext
        
        // create new records
        let project = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context)
        
        let name = txtProjectName.text!
        let priority = segProjectPriority.titleForSegment(at: segProjectPriority.selectedSegmentIndex)!
        let dueDate = selDueDate.date
        let notes = txtNotes.text!
        let addCalendar = swiAddCalendar.isOn
        
        project.setValue(name, forKey: "name")
        project.setValue(priority, forKey: "priority")
        project.setValue(dueDate, forKey: "due")
        project.setValue(notes, forKey: "notes")
        project.setValue(addCalendar, forKey: "calendar")
        
        var alertMessage = "Successfully saved project " + name
        
        do {
            try context.save()
        } catch let error as NSError {
            alertMessage = "An error has occured while saving. Please restart the application and try again. Error info: " + error.localizedDescription
        }
        
        let alert = UIAlertController(title: "Saving Status", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: { ACTION in
            self.btnCancel(UIButton())
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
