//
//  MapsViewController.swift
//  MapTest
//
//  Created by Nishit on 2017-10-14.
//  Copyright © 2017 Nishit. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
class MapsViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet weak var locControl: UISegmentedControl!
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let regionRadius : CLLocationDistance = 5000 // constant
    let initialLocation = CLLocation(latitude: 44.050098, longitude: -79.892573)
    
    @IBOutlet weak var wayTwo: UITextField!
    @IBOutlet weak var wayOne: UITextField!
    @IBOutlet var tbLocEntered : UITextField!
    @IBOutlet var myTableView : UITableView!
    //43.592826, -79.643276 - Square one
    //44.050098, -79.892573
    //(43.597745, -79.640488)
    
   // var loc = Location(filename:"Coordinates")
    var Steps = ["Enter a destination to see the Route"]
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if locControl.selectedSegmentIndex == 0
        {
        return Steps.count
        }
        else if locControl.selectedSegmentIndex == 1
        {
            return Steps.count
        }
        else if locControl.selectedSegmentIndex == 2
        {
            return Steps.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if locControl.selectedSegmentIndex == 0
        {
            return 40
        }
        else if locControl.selectedSegmentIndex == 1
        {
            return 40
        }
        else if locControl.selectedSegmentIndex == 2
        {
            return 40
        }
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
       
        if locControl.selectedSegmentIndex == 0
        {
            tableCell.textLabel?.text = Steps[indexPath.row]
        }
        else if locControl.selectedSegmentIndex == 1
        {
            tableCell.textLabel?.text = Steps[indexPath.row]
            
        }
        else if locControl.selectedSegmentIndex == 2
        {
            tableCell.textLabel?.text = Steps[indexPath.row]
        }
        return tableCell
    }
    
    
    func centerMapOnLocation (location : CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 6.0, regionRadius * 6.0)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerMapOnLocation(location: initialLocation)
        createPolyline(mapView: mapView)
        
        //drop pin
        let dropPin = MKPointAnnotation()
        
        dropPin.coordinate = initialLocation.coordinate
        dropPin.title = "Source"
        
        self.mapView.addAnnotation(dropPin)
        
        self.mapView.selectAnnotation(dropPin, animated: true)
    
    }
    //ADD/CREATE A BOUNDARY HERE
    func createPolyline(mapView: MKMapView) {
        var points=[CLLocationCoordinate2DMake(44.090219, -80.136317),CLLocationCoordinate2DMake(44.191394, -79.702651),CLLocationCoordinate2DMake(44.009789, -79.681048),CLLocationCoordinate2DMake(43.919218, -80.077277)]
        let polygon = MKPolygon(coordinates: &points, count: points.count)
        self.mapView.add(polygon)
        
    }
    
    @IBAction func SearchNewLocation(){
        
        let locEnteredText = tbLocEntered.text
        let wayOneText = wayOne.text
        let wayTwoText = wayTwo.text
        let geoCoder = CLGeocoder()
        let geoCoder1 = CLGeocoder()
        let geoCoder2 = CLGeocoder()
        //BLOCK CODING
        
        geoCoder.geocodeAddressString(locEnteredText!, completionHandler:
            
            {(placemarks, error) -> Void in
                if (error != nil){
                    print("Error", error!)
                }
                if let placemark = placemarks?.first{
                    let coordinates : CLLocationCoordinate2D = placemark.location!.coordinate
                    
                    let newLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                    
                    self.centerMapOnLocation(location: newLocation)
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = coordinates
                    dropPin.title = placemark.name
                    self.mapView.addAnnotation(dropPin)
                    self.mapView.selectAnnotation(dropPin, animated: true)
                    
                    let request = MKDirectionsRequest()
                    request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.initialLocation.coordinate, addressDictionary: nil))
                    
                    request.destination = MKMapItem(placemark:MKPlacemark(coordinate: coordinates, addressDictionary: nil))
                    
                    request.requestsAlternateRoutes = false
                    request.transportType = .automobile
                    
                    let directions = MKDirections(request:request)
                    directions.calculate(completionHandler:
                        
                        {[unowned self] response, error in
                            
                            for route in (response?.routes)!{
                                self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
                                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                                self.Steps.removeAll()
                             if(self.locControl.selectedSegmentIndex == 0)
                             {
                                    for step in route.steps {
                                    self.Steps.append(step.instructions)
                                        }
                                
                                self.myTableView.reloadData()
                                }
                            }
                        }
                        
                    )
                }
        }
        )
        
        geoCoder1.geocodeAddressString(wayOneText!, completionHandler:
            
            {(placemarks, error) -> Void in
                if (error != nil){
                    print("Error", error!)
                }
                if let placemark = placemarks?.first{
                    let coordinates : CLLocationCoordinate2D = placemark.location!.coordinate
                    
                    let newLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                    
                    self.centerMapOnLocation(location: newLocation)
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = coordinates
                    dropPin.title = placemark.name
                    self.mapView.addAnnotation(dropPin)
                    self.mapView.selectAnnotation(dropPin, animated: true)
                    
                    let request = MKDirectionsRequest()
                    request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.initialLocation.coordinate, addressDictionary: nil))
                    
                    request.destination = MKMapItem(placemark:MKPlacemark(coordinate: coordinates, addressDictionary: nil))
                    
                    request.requestsAlternateRoutes = false
                    request.transportType = .automobile
                    
                    let directions = MKDirections(request:request)
                    directions.calculate(completionHandler:
                        
                        {[unowned self] response, error in
                            
                            for route in (response?.routes)!{
                                self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
                                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                                self.Steps.removeAll()
                          if(self.locControl.selectedSegmentIndex == 1)
                          {
                                for step in route.steps {
                                    self.Steps.append(step.instructions)
                                }
                            
                                self.myTableView.reloadData()
                        }
                            }
                        }
                        
                    )
                }
        }
        )
        
        geoCoder2.geocodeAddressString(wayTwoText!, completionHandler:
            
            {(placemarks, error) -> Void in
                if (error != nil){
                    print("Error", error!)
                }
                if let placemark = placemarks?.first{
                    let coordinates : CLLocationCoordinate2D = placemark.location!.coordinate
                    
                    let newLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                    
                    self.centerMapOnLocation(location: newLocation)
                    let dropPin = MKPointAnnotation()
                    dropPin.coordinate = coordinates
                    dropPin.title = placemark.name
                    self.mapView.addAnnotation(dropPin)
                    self.mapView.selectAnnotation(dropPin, animated: true)
                    
                    let request = MKDirectionsRequest()
                    request.source = MKMapItem(placemark: MKPlacemark(coordinate: self.initialLocation.coordinate, addressDictionary: nil))
                    
                    request.destination = MKMapItem(placemark:MKPlacemark(coordinate: coordinates, addressDictionary: nil))
                    
                    request.requestsAlternateRoutes = false
                    request.transportType = .automobile
                    
                    let directions = MKDirections(request:request)
                    directions.calculate(completionHandler:
                        
                        {[unowned self] response, error in
                            
                            for route in (response?.routes)!{
                                self.mapView.add(route.polyline, level: MKOverlayLevel.aboveRoads)
                                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                                self.Steps.removeAll()
                      if(self.locControl.selectedSegmentIndex == 2)
                      {
                                for step in route.steps {
                                    self.Steps.append(step.instructions)
                                }
                        
                                self.myTableView.reloadData()
                        }
                                
                            }
                        }
                        
                    )
                }
        }
        )
        self.myTableView.reloadData()
    }

    
    //func addBoundary() {
      //  mapView.add(MKPolygon(coordinates: loc.boundary, count: loc.boundary.count))
   // }

    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
     if overlay is MKPolyline
        {
            let polylineView = MKPolylineRenderer(polyline: overlay as! MKPolyline)
            polylineView.strokeColor = UIColor.green
            polylineView.lineWidth = 3.0
            return polylineView
        }
        
        else if overlay is MKPolygon
        {
        let polygonView = MKPolygonRenderer(polygon: overlay as! MKPolygon)
        polygonView.strokeColor = UIColor.red
        polygonView.lineWidth = 4.5
        return polygonView
        }
        
        return MKOverlayRenderer()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
