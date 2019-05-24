//
//  DetailViewController.swift
//  Coursework2
//
//  Created by Rukshan Hassim on 5/19/19.
//  Copyright © 2019 Rukshan Hassim. All rights reserved.
//

import UIKit

protocol SelectedProject {
    func getSelectedProject() -> Project
}

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SelectedProject {
    
    func getSelectedProject() -> Project {
        return selectedProject!
    }
    
    let list = ["Please", "work", "man"]
    var selectedProject:Project? = nil
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = list[indexPath.row]
        
        return cell
    }

    func configureView() {
        // Update the user interface for the project item.
        if let detail = detailItem {
            selectedProject = detail
            
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    var detailItem: Project? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let taskPopUp = segue.destination as? TaskPopUpViewController {
            taskPopUp.selectedProject = self
        }
    }
    
}

