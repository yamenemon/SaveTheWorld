//
//  LocationSearchViewController.swift
//  SaveTheWorld
//
//  Created by MAC MINI on 23/2/19.
//  Copyright © 2019 Binate Solutions. All rights reserved.
//

import UIKit
import MapKit

protocol HandleMapSearch: class {
    func dropPinZoomIn(placemark:MKPlacemark)
}
protocol getUserLocationDelegate{
    func sendUserLocation(userLocationName: String, coordinate: CLLocationCoordinate2D)
}

class LocationSearchViewController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    var delegate: getUserLocationDelegate?

    var resultSearchController: UISearchController!
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    var selectedPin: MKPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for Hospitals"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
        
    }
    private func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView?.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        guard !(annotation is MKUserLocation) else { return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true

        let smallSquare = CGSize(width: 30, height: 30)
        let btn = UIButton(frame: CGRect(origin: .zero, size: smallSquare))
        btn.setBackgroundImage(UIImage(named: "SaveLives"), for: .normal)
        btn.addTarget(self, action: #selector(LocationSearchViewController.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = btn
        
        return pinView
    }
    @objc func getDirections(){
        guard let selectedPin = selectedPin else { return }
//        let mapItem = MKMapItem(placemark: selectedPin)
//        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//        mapItem.openInMaps(launchOptions: launchOptions)
        self.delegate?.sendUserLocation(userLocationName: selectedPin.name!, coordinate: selectedPin.coordinate)
        self.navigationController?.popViewController(animated: true)
    }
    func SendUserLocation(userLocation: String){
        
    }
}
extension LocationSearchViewController : HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        
        // clear existing pins
        mapView?.removeAnnotations((mapView?.annotations)!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        
        mapView?.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView?.setRegion(region, animated: true)
    }
}

