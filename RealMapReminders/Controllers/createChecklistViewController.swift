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
import MapKit

protocol HandleMapSearch3 {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class createChecklistViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    var selectedPin:MKPlacemark? = nil
    var resultSearchController:UISearchController? = nil
    let annotation = MKPointAnnotation()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        self.hideKeyboardWhenTappedAround()
        annotation.coordinate = CLLocationCoordinate2DMake(37.773514, -122.417807)
        mapView2.addAnnotation(annotation)
    }
    

    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var mapView2: MKMapView!
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
          guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "save" where reminder != nil:
            guard let destination = segue.destination as? checklistTableViewController else { return }
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
            guard let destination = segue.destination as? checklistTableViewController else { return }
            let reminder = CoreDataHelper.newReminder()
            reminder.textField_1 = oneTextField.text ?? ""
            reminder.textField_2 = twoTextField.text ?? ""
            reminder.textField_3 = threeTextField.text ?? ""
            reminder.textField_4 = fourTextField.text ?? ""
            reminder.textField_5 = fiveTextField.text ?? ""
            reminder.textField_6 = sixTextField.text ?? ""
            reminder.locationTitle = locationTextField.text ?? ""
            
        case "setNewLocation" where reminder != nil:
//            print("Jumping to mapViewController")
            
            guard let destination = segue.destination as? UINavigationController else { return }
            guard let mapViewController = destination.viewControllers.first as? MapViewController else { return }
            mapViewController.delegate = self
            
            reminder?.textField_1 = oneTextField.text ?? ""
            reminder?.textField_2 = twoTextField.text ?? ""
            reminder?.textField_3 = threeTextField.text ?? ""
            reminder?.textField_4 = fourTextField.text ?? ""
            reminder?.textField_5 = fiveTextField.text ?? ""
            reminder?.textField_6 = sixTextField.text ?? ""
            reminder?.locationTitle = locationTextField.text ?? ""
            
        //    destination.delegate?.
            
        default:
            print("unexpected segue identifier")
        }
    }
    
    // write a method that will dismiss the uibutton
    func dismissNewLocationButton() {
        setNewLocationButton.isHidden = true
    }
    
    // implement map kit then pass along coordinates from your reminder model to the map and display pin
    func displayHomeLocation() {
        
    }
}

extension createChecklistViewController: MapViewControllerDelegate{
    func updateLocationPin() {
        dismissNewLocationButton()
       // displayHomeLocation()
    }
}

extension createChecklistViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView2.removeAnnotations(mapView2.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "(city) (state)"
        }
        mapView2.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(placemark.coordinate, span)
        mapView2.setRegion(region, animated: true)
    }
}




