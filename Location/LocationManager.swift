//
//  LocationManager.swift
//  Location
//
//  Created by jht2 on 4/6/22.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
  
  private let locationManager = CLLocationManager()
  @Published var locationStatus: CLAuthorizationStatus?
  @Published var lastLocation: CLLocation?
  @Published var region:MKCoordinateRegion
  @Published var delta: Double
    
  override init() {
    delta = 0.005
    region = MKCoordinateRegion()
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
  }
  
  var userLatitude: String {
    return "\(lastLocation?.coordinate.latitude ?? 0)"
  }
  
  var userLongitude: String {
    return "\(lastLocation?.coordinate.longitude ?? 0)"
  }

  var statusString: String {
    guard let status = locationStatus else {
      return "unknown"
    }
    switch status {
    case .notDetermined: return "notDetermined"
    case .authorizedWhenInUse: return "authorizedWhenInUse"
    case .authorizedAlways: return "authorizedAlways"
    case .restricted: return "restricted"
    case .denied: return "denied"
    default: return "unknown"
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    locationStatus = status
    print("locationManager didChangeAuthorization", statusString)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    lastLocation = location
    let lat = lastLocation?.coordinate.latitude ?? 0
    let long = lastLocation?.coordinate.longitude ?? 0
    let loc = CLLocationCoordinate2D(latitude: lat, longitude: long)
    // let delta = 0.005
    region = MKCoordinateRegion(center: loc, span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta))
    print("locationManager didUpdateLocations", location)
  }
  
}
