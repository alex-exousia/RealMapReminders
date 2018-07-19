//
//  mapViewController.swift
//  RealMapReminders
//
//  Created by Alexander Niehaus on 7/19/18.
//  Copyright © 2018 Make School. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch2 {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class mapViewController: UIViewController{
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var selectedPin:MKPlacemark? = nil
    var resultSearchController:UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "TwoLocationSearchTable") as! TwoLocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Set New Location"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        //    let geofenceRegionCenter = CLLocationCoordinate2DMake(37.773485, -122.417719)
        //   let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter,radius: 100,identifier: "UniqueIdentifier")
    }
}

extension mapViewController: CLLocationManagerDelegate {
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            
            // print("location:: \(location)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
}

extension mapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        selectedPin = placemark
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake (placemark.coordinate, span)
        
        //Save these to core data to re-render later
        let latToSave = placemark.coordinate.latitude
        let longToSave = placemark.coordinate.longitude
        let savedLocation = CoreDataHelper.newLocation()
        savedLocation.latToSave = latToSave
        savedLocation.longToSave = longToSave
        CoreDataHelper.saveLocation()
        mapView.setRegion(region, animated: true)
        print("\(latToSave) , \(longToSave)")
        let Loco = CoreDataHelper.retrieveLocation()
        print("\(Loco)")
        
    }
}

