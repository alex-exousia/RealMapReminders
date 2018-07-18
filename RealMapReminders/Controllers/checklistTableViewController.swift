//
//  ChecklistTableViewController.swift
//  RealMapReminders
//
//  Created by Alexander Niehaus on 7/18/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import UIKit

class checklistTableViewController: UITableViewController {
    
        var reminders = [Reminder]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    
    @IBAction func unwindWithSegue(_ segue: UIStoryboardSegue) {
        reminders = CoreDataHelper.retrieveReminders()
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reminders = CoreDataHelper.retrieveReminders()

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return reminders.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checklistTableViewCell", for: indexPath) as! checklistTableViewCell
      
        let reminder = reminders[indexPath.row]
        cell.locationTitleLabel.text = reminder.locationTitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let reminderToDelete = reminders[indexPath.row]
        if editingStyle == .delete {
            CoreDataHelper.deleteReminder(reminder: reminderToDelete)
            reminders = CoreDataHelper.retrieveReminders()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "viewReminder":
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let reminder = reminders[indexPath.row]
            let destination = segue.destination as! createChecklistViewController
            destination.reminder = reminder
            
        case "addReminder":
            print("create new reminder bar button item tapped")
            
        default:
            print("unexpected segue identifier")
        }
    }
    

}
