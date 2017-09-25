//
//  MapViewController.swift
//  HW5_Map_Kit
//
//  Created by Stephen on 9/22/17.
//  Copyright © 2017 Stephen. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate{

    //Display string for address map
    var fromPlace = ""
    var toPlace = ""
    var showType = "" //either "map" or "route"
    var geocoder = CLGeocoder()
    var places = [String]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsScale = true
        mapView.showsPointsOfInterest = true;
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        print("fromPlace = " + fromPlace)
        print("toPlace = " + toPlace)
        if (!fromPlace.isEmpty) {
            places.append(fromPlace)
        }
        if (!toPlace.isEmpty) {
            places.append(toPlace)
        }
        if showType == "map" {
            showRouteOnMap(places: places, polyline: false)
        } else if showType == "route" {
            showRouteOnMap(places: places, polyline: true)
        }
    }

    func showRouteOnMap(places:[String], polyline:Bool) {
        var i = 1
        var coordinates: CLLocationCoordinate2D?
        var placemark: CLPlacemark?
        var annotation: Station?
        var stations:Array = [Station]()
        var points: [CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        
        for address in places {
            geocoder = CLGeocoder() //new geocoder
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil)  {
                    print("Error", error!)
                }
                placemark = placemarks?.first
                if placemark != nil {
                    coordinates = placemark!.location!.coordinate
                    points.append(coordinates!)
                    print("locations = \(coordinates!.latitude) \(coordinates!.longitude)")
                    annotation = Station(latitude: coordinates!.latitude, longitude: coordinates!.longitude, address: address)
                    stations.append(annotation!)
                    print(stations.count)
                    print(i)
                    
                    if (i == self.places.count) {
                        print("Print map...")
                        self.mapView.addAnnotations(stations)
                        
                        if (polyline == true) { //If draw polyline is true
                            print("Draw Stephen!!!")
                            let request = MKDirectionsRequest()
                            request.source = MKMapItem(placemark: MKPlacemark(coordinate: points[0], addressDictionary: nil))
                            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: points[1], addressDictionary: nil))
                            request.requestsAlternateRoutes = true
                            request.transportType = .automobile
                            
                            let directions = MKDirections(request: request)
                            
                            directions.calculate { [unowned self] response, error in
                                guard let unwrappedResponse = response else { return }
                                
                                if (unwrappedResponse.routes.count > 0) {
                                    self.mapView.add(unwrappedResponse.routes[0].polyline)
                                    self.mapView.setVisibleMapRect(unwrappedResponse.routes[0].polyline.boundingMapRect, animated: true)
                                    
                                    /*let annotation = MKPointAnnotation()
                                    annotation.coordinate = points[0]
                                    annotation.title = "Time"
                                    annotation.subtitle = "\(unwrappedResponse.routes[0].expectedTravelTime) mins"
                                    self.mapView.addAnnotation(annotation)*/
                                }
                            }
                        }
                    }
                    i += 1
                }
            })
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
        return MKPolylineRenderer()
    }

    class Station: NSObject, MKAnnotation {
        var title: String?
        var latitude: Double
        var longitude:Double
        
        var coordinate: CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        init(latitude: Double, longitude: Double, address: String) {
            self.latitude = latitude
            self.longitude = longitude
            self.title = address
        }
    }
}
