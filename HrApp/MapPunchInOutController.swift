//
//  MapPunchInOutController.swift
//  HrApp
//
//  Created by Goldmedal on 1/8/20.
//  Copyright © 2020 Goldmedal. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapPunchInOutController: BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var btnPunchIn: UIButton!
    
    let mLat = 19.182755
    let mLong = 72.840157
    
    //let mLat = 37.36657341
    //let mLong = -122.13598643
  
    let locationManager = CLLocationManager()
    
    var streetNumber : String?
    var streetName : String?
    var pinCode : String?
    var country : String?
    var locality : String?
    var subLocality : String?
    var administrativeArea : String?
    
    var previousLocation: CLLocation?
    
    var isFirstTime = true
    var checkPunchStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSlideMenuButton()
        
        checkPunchStatus = (UserDefaults.standard.bool(forKey: "punchStatus") as! Bool)
        
        if(checkPunchStatus){
            self.btnPunchIn.setTitle("Check Out", for: .normal)
        }else{
            self.btnPunchIn.setTitle("Check In", for: .normal)
        }
        
        checkLocationServices()
    }
    
    
    @IBAction func clicked_back(_ sender: Any) {
        self.navigationController!.popViewController(animated: true)
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 10, longitudinalMeters: 10)
            mapView.setRegion(region, animated: true)
        }
    }
    
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            // Show alert letting the user know they have to turn this on.
        }
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            startTackingUserLocation()
        case .denied:
            // Show alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            // Show an alert letting them know what's up
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    
    func startTackingUserLocation() {
        setupData()
        mapView.showsUserLocation = true
        centerViewOnUserLocation()
        locationManager.startUpdatingLocation()
        previousLocation = getCenterLocation(for: mapView)
    }
    
    
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let center = getCenterLocation(for: mapView)
        let geoCoder = CLGeocoder()
        
        guard let previousLocation = self.previousLocation else { return }
        
        if(isFirstTime){
            isFirstTime = false
        }else{
            guard center.distance(from: previousLocation) > 50 else { return }
        }
        
        
        self.previousLocation = center
        
        geoCoder.reverseGeocodeLocation(center) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let _ = error {
                //TODO: Show alert informing the user
                return
            }
            
            guard let placemark = placemarks?.first else {
                //TODO: Show alert informing the user
                return
            }
            
            self.streetNumber = placemark.subThoroughfare ?? ""
            self.streetName = placemark.thoroughfare ?? ""
            self.pinCode = placemark.postalCode ?? ""
            self.country = placemark.country ?? ""
            self.locality = placemark.locality ?? ""
            self.subLocality = placemark.subLocality ?? ""
            self.administrativeArea = placemark.administrativeArea ?? ""
         
        }
    }
    
    func showAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func onPunchInClicked(_ sender: Any) {
        
        var expectedLocation = CLLocation(latitude: mLat, longitude: mLong)
        let distanceMeters = previousLocation?.distance(from: expectedLocation)
        print("Distance - - - ",distanceMeters," - - - - ",previousLocation)
        
        print("\(self.streetNumber) \(self.streetName) \(self.subLocality) \(self.locality) \(self.pinCode) \(self.administrativeArea) \(self.country)")
        
        if (distanceMeters ?? 0) > 5000 { // Some distance filter
            showAlert("You are outside the radius")
        } else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "PunchInPopup", bundle: nil)
            let confirmPopup = storyBoard.instantiateViewController(withIdentifier: "PunchInPopup") as! PunchInPopup
            confirmPopup.punchLocationAddress = "\(self.streetNumber ?? "") \(self.streetName ?? "") \(self.subLocality ?? "") \(self.locality ?? "") \(self.pinCode ?? "") \(self.administrativeArea ?? "") \(self.country ?? "")"
            confirmPopup.mLat = String(previousLocation?.coordinate.latitude ?? 0)
            confirmPopup.mLong = String(previousLocation?.coordinate.longitude ?? 0)
            
            self.present(confirmPopup, animated: true, completion: nil)
        }
    }
    
        func setupData() {
            // check if can monitor regions
            if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
    
                // region data
                let title = "Goldmedal Electrical Pvt Ltd"
                let coordinate = CLLocationCoordinate2DMake(mLat, mLong)
                let regionRadius = 5000.0
    
                // setup region
                let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,
                                                                             longitude: coordinate.longitude), radius: regionRadius, identifier: title)
                locationManager.startMonitoring(for: region)
    
                // setup annotation
                let restaurantAnnotation = MKPointAnnotation()
                restaurantAnnotation.coordinate = coordinate;
                restaurantAnnotation.title = "\(title)";
                mapView.addAnnotation(restaurantAnnotation)
    
                // setup circle
                let circle = MKCircle(center: coordinate, radius: regionRadius)
                mapView.addOverlay(circle)
            }
            else {
                print("System can't track regions")
            }
        }
    
    
        // MARK: - MKMapViewDelegate
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.strokeColor = UIColor.red
            circleRenderer.lineWidth = 2.0
            circleRenderer.fillColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.1)
            return circleRenderer
        }
    
        // MARK: - CLLocationManagerDelegate
        func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
            showAlert("enter \(region.identifier)")
        }
    
        func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
            showAlert("exit \(region.identifier)")
        }
    
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            print("location - - -",locations)
            previousLocation = locations[0]
        }
    
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print(error)
        }
    
}
