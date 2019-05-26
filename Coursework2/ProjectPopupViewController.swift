//
//  ProjectPopupViewController.swift
//  Coursework2
//
//  Created by Rukshan Hassim on 5/24/19.
//  Copyright © 2019 Rukshan Hassim. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class ProjectPopupViewController: UIViewController {
    
    @IBOutlet weak var txtProjectName: UITextField!
    @IBOutlet weak var segProjectPriority: UISegmentedControl!
    @IBOutlet weak var selDueDate: UIDatePicker!
    @IBOutlet weak var txtNotes: UITextField!
    @IBOutlet weak var swiAddCalendar: UISwitch!
    
    var isUpdate: Bool?
    var updateProject: NSManagedObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isUpdate ?? false {
            let priorityText = updateProject?.value(forKey: "priority") as? String
            var priorityIndex = 0
            
            if priorityText == "Medium" {
                priorityIndex = 1
            } else if priorityText == "High" {
                priorityIndex = 2
            }
            
            txtProjectName.text = updateProject?.value(forKey: "name") as? String
            segProjectPriority.selectedSegmentIndex = priorityIndex
            selDueDate.date = updateProject?.value(forKey: "due") as! Date
            txtNotes.text = updateProject?.value(forKey: "notes") as? String
            swiAddCalendar.isOn = updateProject?.value(forKey: "calendar") as! Bool
        }
    }
    
    @IBAction func btnSave(_ sender: Any) {
        
        let name = txtProjectName.text!
        let priority = segProjectPriority.titleForSegment(at: segProjectPriority.selectedSegmentIndex)!
        let dueDate = selDueDate.date
        let notes = txtNotes.text!
        let addCalendar = swiAddCalendar.isOn
        
        var alertMessage = "Successfully saved project " + name
        
        do {
            if isUpdate ?? false {
                updateProject?.setValue(name, forKey: "name")
                updateProject?.setValue(priority, forKey: "priority")
                updateProject?.setValue(dueDate, forKey: "due")
                updateProject?.setValue(notes, forKey: "notes")
                updateProject?.setValue(addCalendar, forKey: "calendar")
                
                try updateProject?.managedObjectContext?.save()
            } else {
                // connect to app delegate
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                // create DB context
                let context = appDelegate.persistentContainer.viewContext
                
                // create new records
                let project = NSEntityDescription.insertNewObject(forEntityName: "Project", into: context)
                
                project.setValue(name, forKey: "name")
                project.setValue(priority, forKey: "priority")
                project.setValue(dueDate, forKey: "due")
                project.setValue(notes, forKey: "notes")
                project.setValue(addCalendar, forKey: "calendar")
                
                try context.save()
                
                let projectCreated = project as! Project
                if projectCreated.calendar {
                    addToCalendar(project: projectCreated)
                }
            }
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
    
    func addToCalendar(project: Project) {
        let store = EKEventStore()
        
        store.requestAccess(to: .event, completion: {(success, error) in
            if error == nil {
                let event = EKEvent.init(eventStore: store)
                event.title = project.name
                event.calendar = store.defaultCalendarForNewEvents
                event.startDate = project.due
                event.endDate = project.due! + 1
                
                do {
                    try store.save(event, span: .thisEvent)
                } catch let error as Error {
                    print("Failed : " + error.localizedDescription)
                }
            } else {
                print("Failed : " + (error?.localizedDescription)!)
            }
        })
    }
    
}
