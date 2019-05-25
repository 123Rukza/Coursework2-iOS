//
//  DetailViewController.swift
//  Coursework2
//
//  Created by Rukshan Hassim on 5/19/19.
//  Copyright © 2019 Rukshan Hassim. All rights reserved.
//

import UIKit
import CoreData

protocol SelectedProject {
    func getSelectedProject() -> Project
}

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SelectedProject, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    var selectedProject:Project? = nil
    
    @IBOutlet weak var projectPercentage: M13ProgressViewPie!
    @IBOutlet weak var projectPercentageLabel: UILabel!
    @IBOutlet weak var projectDaysRemaining: M13ProgressViewPie!
    @IBOutlet weak var projectDaysRemainingLabel: UILabel!
    @IBOutlet weak var projectMainTitle: UILabel!
    @IBOutlet weak var projectSubTitle: UILabel!
    @IBOutlet weak var projectNotes: UILabel!
    @IBOutlet weak var taskTableView: UITableView!
    
    func updateProjectArea() {
        
        var taskList = fetchedResultsController?.fetchedObjects as! [Task]
        var earliestDate = Date()
        
        var i = 0
        var percentage = 0
        while i < taskList.count {
            percentage += Int(taskList[i].percentage)
            
            if taskList[i].start! < earliestDate {
                earliestDate = taskList[i].start!
            }
            
            i += 1
        }
        
        let percentComplete:Double = Double(percentage)/Double(i)
        
        projectPercentageLabel.text! = String(format: "%.2f", percentComplete) + "% Complete"
        projectPercentage.setProgress(CGFloat((percentComplete/100.0)), animated: true)
        
        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: (selectedProject?.due!)!).day
        projectDaysRemainingLabel.text = String(daysLeft!) + " days left"
        
        
//        INCOMPLETE
        let totalDays = Calendar.current.dateComponents([.day], from: earliestDate, to: (selectedProject?.due!)!).day
        let daysSpent = Calendar.current.dateComponents([.day], from: earliestDate, to: Date()).day
        let daysSpentPercent:Double = Double(daysSpent!)/Double(totalDays!)
        
        projectDaysRemaining.setProgress(CGFloat(daysSpentPercent/100.0), animated: true)
    }
    
    func setProjectNames() {
        projectMainTitle.text = "Project " + (selectedProject?.name)! + " - Summary"
        projectSubTitle.text = "Priority status - " + (selectedProject?.priority!)!
        projectNotes.text = selectedProject?.notes!
    }
    
    func getSelectedProject() -> Project {
        return selectedProject!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = fetchedResultsController!.object(at: indexPath) as! Task
        let taskName = task.name!
        let taskDescription = String((task.end?.description.prefix(16))!)
        let taskPercentage:Double = Double(task.percentage)/100.0
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TaskTableViewCell
        cell.taskNumber.text = "Task " + String(indexPath.row + 1)
        
        cell.progressBar.setProgress(CGFloat(taskPercentage), animated: true)
        
        cell.taskName.text = taskName + " - Due: " + taskDescription
        return cell
    }
    
    var detailItem: Project? {
        didSet {
            self.loadViewIfNeeded()
            setProjectNames()
            configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the project item.
        if let detail = detailItem {
            selectedProject = detail
            
            // connect to app delegate
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            // create DB context
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchedResultsController?.delegate = self
            fetchedResultsController!.fetchRequest.predicate = NSPredicate(format: "master == %@", selectedProject!)
            
            do {
                try fetchedResultsController!.performFetch()
            } catch {
                fatalError("Error getting data from Core Data")
            }
            
            taskTableView.reloadData()
            
            if (selectedProject != nil) {
                updateProjectArea()
            }
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        taskTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        taskTableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                taskTableView.insertRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                let cell = taskTableView.cellForRow(at: indexPath) as! TaskTableViewCell
                // DO CELL UPDATE HERE WITH INDEXPATH
            }
            break
        case .delete:
            if let indexPath = indexPath {
                taskTableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.fade)
            }
            break
        case .move:
            print("")
            // NO MOVING IN THIS APPLICATION
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let taskPopUp = segue.destination as? TaskPopUpViewController {
            taskPopUp.selectedProject = self
        }
    }
    
}

