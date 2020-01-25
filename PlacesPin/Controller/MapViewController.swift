//
//  MapViewController.swift
//  PlacesPin
//
//  Created by Santiago Alfonso Limas Garay on 10/10/19.
//  Copyright © 2019 Santiago Alfonso Limas Garay. All rights reserved.
//

import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {

    var place: PlaceMO!
    var currentPlacemark: CLPlacemark?
    var currentTransportType = MKDirectionsTransportType.automobile
    var currentRoute: MKRoute?
    
    let locationManager = CLLocationManager()
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var mapView: MKMapView!
    @IBAction func showDirection(sender: UIButton){
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0: currentTransportType = .automobile
        case 1: currentTransportType = .walking
        default: break
            
        }
        
        segmentedControl.isHidden = false;
  
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: UIControl.State.normal)

        
        guard let currentPlacemark = currentPlacemark else {
                return
        }

        let directionRequest = MKDirections.Request()

        // Source and destination of the route
        directionRequest.source = MKMapItem.forCurrentLocation()
        let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
        directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
        directionRequest.transportType = currentTransportType
        
        // Calculate direction
        let directions = MKDirections(request: directionRequest)

        directions.calculate { (routeResponse, routeError) -> Void in

            guard let routeResponse = routeResponse else {
                if let routeError = routeError {
                    print("Error: \(routeError)")
                }

                return
            }

            let route = routeResponse.routes[0]
            self.currentRoute = route
            self.mapView.removeOverlays(self.mapView.overlays)
            self.mapView.addOverlay(route.polyline, level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegion(rect), animated: true)

            

        }
        

    }
    
  

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3.0

        return renderer
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.showsTraffic = true
        
        // Convert address to coordinate and annotate it on map
            let geoCoder = CLGeocoder()
        
            geoCoder.geocodeAddressString(place.location ?? "", completionHandler: { placemarks, error in
                
                if let error = error {
                    print(error)
                    return
                }

                if let placemarks = placemarks {
                    // Get the first placemark
                    let placemark = placemarks[0]
                    self.currentPlacemark = placemark

                    // Add annotation
                    let annotation = MKPointAnnotation()
                    annotation.title = self.place.name
                    annotation.subtitle = self.place.type

                    if let location = placemark.location {
                        annotation.coordinate = location.coordinate

                        // Display the annotation
                        self.mapView.showAnnotations([annotation], animated: true)
                        self.mapView.selectAnnotation(annotation, animated: true)
                    }
                }

            })
        

        //Request for authorization
        locationManager.requestWhenInUseAuthorization()
        let status = CLLocationManager.authorizationStatus()
        
        //Show depending on the authorization
        if status == CLAuthorizationStatus.authorizedWhenInUse{
            mapView.showsUserLocation = true
        }
        
        
        segmentedControl.isHidden = true
        
        segmentedControl.addTarget(self, action: #selector(showDirection), for: .valueChanged)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "MyMarker"

        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }

        // Reuse the annotation if possible
                
        var annotationView: MKAnnotationView?
        
        if #available(iOS 11.0, *) {
            var markerAnnotationView: MKMarkerAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
            
            if markerAnnotationView == nil {
                markerAnnotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                markerAnnotationView?.canShowCallout = true
            }
            
            markerAnnotationView?.glyphText = "▼"
            markerAnnotationView?.glyphTintColor = .white
            markerAnnotationView?.markerTintColor = UIColor.black
        
            annotationView = markerAnnotationView
            
        } else {
            
            var pinAnnotationView: MKPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            
            if pinAnnotationView == nil {
                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pinAnnotationView?.canShowCallout = true
                pinAnnotationView?.pinTintColor = UIColor.orange
            }
            
            annotationView = pinAnnotationView
        }
 
        annotationView?.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.detailDisclosure)

        return annotationView
    }
    
    
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//
//        performSegue(withIdentifier: "showSteps", sender: view)
//        
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        if segue.identifier == "showSteps" {
//
//            let routeTableViewController = segue.destination.children[0] as! RouteTableViewController
//            if let steps = currentRoute?.steps {
//                routeTableViewController.routeSteps = steps
//            }
//        }
//    }


    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
