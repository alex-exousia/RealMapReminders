//
//  createChecklistViewController.swift
//  RealMapReminders
//
//  Created by Alexander Niehaus on 7/18/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class createChecklistViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.hideKeyboardWhenTappedAround() 
    }
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var oneTextField: UITextField!
    @IBOutlet weak var twoTextField: UITextField!
    @IBOutlet weak var threeTextField: UITextField!
    @IBOutlet weak var fourTextField: UITextField!
    @IBOutlet weak var fiveTextField: UITextField!
    @IBOutlet weak var sixTextField: UITextField!
    @IBOutlet weak var setNewLocationButton: UIButton!
    
    var reminder: Reminder?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNewLocationButton.layer.cornerRadius = 7
        
        if let reminder = reminder {
            oneTextField.text = reminder.textField_1
            twoTextField.text = reminder.textField_2
            threeTextField.text = reminder.textField_3
            fourTextField.text = reminder.textField_4
            fiveTextField.text = reminder.textField_5
            sixTextField.text = reminder.textField_6
            locationTextField.text = reminder.locationTitle
            
            
        } else {
            oneTextField.text = ""
            twoTextField.text = ""
            threeTextField.text = ""
            fourTextField.text = ""
            fiveTextField.text = ""
            sixTextField.text = ""
            locationTextField.text = ""
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
          guard let identifier = segue.identifier,
          let destination = segue.destination as? checklistTableViewController
           else { return }
        
        switch identifier {
        // 2
        case "save" where reminder != nil:
            reminder?.textField_1 = oneTextField.text ?? ""
            reminder?.textField_2 = twoTextField.text ?? ""
            reminder?.textField_3 = threeTextField.text ?? ""
            reminder?.textField_4 = fourTextField.text ?? ""
            reminder?.textField_5 = fiveTextField.text ?? ""
            reminder?.textField_6 = sixTextField.text ?? ""
            reminder?.locationTitle = locationTextField.text ?? ""

            destination.tableView.reloadData()
            
        // 3
        case "save" where reminder == nil:
            let reminder = CoreDataHelper.newReminder()
            reminder.textField_1 = oneTextField.text ?? ""
            reminder.textField_2 = twoTextField.text ?? ""
            reminder.textField_3 = threeTextField.text ?? ""
            reminder.textField_4 = fourTextField.text ?? ""
            reminder.textField_5 = fiveTextField.text ?? ""
            reminder.textField_6 = sixTextField.text ?? ""
            reminder.locationTitle = locationTextField.text ?? ""
            
        case "setNewLocation":
            print("")
            
        default:
            print("unexpected segue identifier")
        }
    }

}



