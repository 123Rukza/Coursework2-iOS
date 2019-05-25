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

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SelectedProject {
    
    var taskList: [Task] = []
    var selectedProject:Project? = nil
    
    @IBOutlet weak var projectPercentage: M13ProgressViewPie!
    @IBOutlet weak var projectPercentageLabel: UILabel!
    @IBOutlet weak var projectDaysRemaining: M13ProgressViewPie!
    @IBOutlet weak var projectDaysRemainingLabel: UILabel!
    @IBOutlet weak var projectMainTitle: UILabel!
    @IBOutlet weak var projectSubTitle: UILabel!
    @IBOutlet weak var projectNotes: UILabel!
    
    func updateProjectArea() {
        
        if (taskList.count > 0) {
            
            
            var i = 0
            var percentage = 0
            while i < taskList.count {
                percentage += Int(taskList[i].percentage)
                i += 1
            }
            
            let percentComplete:Double = Double(percentage/i)
            
            projectPercentageLabel.text! = String(percentComplete) + "% Complete"
            projectPercentage.setProgress(CGFloat((percentComplete/100.0)), animated: true)
            
            let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: (selectedProject?.due!)!).day
            projectDaysRemainingLabel.text = String(daysLeft!) + " days left"
            
            let totalDays = Calendar.current.dateComponents([.day], from: Date(), to: (selectedProject?.due!)!).day
        }
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
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let taskName = taskList[indexPath.row].name!
        let taskDescription = String((taskList[indexPath.row].end?.description.prefix(16))!)
        let taskPercentage:Double = Double(taskList[indexPath.row].percentage)/100.0
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TaskTableViewCell
        cell.taskNumber.text = "Task " + String(indexPath.row + 1)
        
        cell.progressBar.setProgress(CGFloat(taskPercentage), animated: true)
        
        cell.taskName.text = taskName + " - Due: " + taskDescription
        return cell
    }
    
    var detailItem: Project? {
        didSet {
            // Update the view.
            self.loadViewIfNeeded()
            setProjectNames()
            configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the project item.
        if let detail = detailItem {
            selectedProject = detail
            
            taskList = (selectedProject?.tasks?.allObjects as! [Task])
            taskList.reverse()
            
            if (selectedProject != nil) {
                updateProjectArea()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let taskPopUp = segue.destination as? TaskPopUpViewController {
            taskPopUp.selectedProject = self
        }
    }
    
}

