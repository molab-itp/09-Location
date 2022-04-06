//
//  ContentView.swift
//  Location
//
//  Created by jht2 on 4/5/22.
//

import SwiftUI
import MapKit

struct ContentView: View {
  
  @StateObject var locationManager = LocationManager()
  
  var userLatitude: String {
    return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
  }
  
  var userLongitude: String {
    return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
  }
  
  var loc: CLLocationCoordinate2D {
    let lat = locationManager.lastLocation?.coordinate.latitude ?? 0
    let long = locationManager.lastLocation?.coordinate.longitude ?? 0
    return CLLocationCoordinate2D(latitude: lat, longitude: long)
  }
  
//  @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.50007773, longitude: -0.1246402),
//                                                 span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))

  var body: some View {
    VStack {
      ZStack {
        Map(coordinateRegion: $locationManager.region)
          .ignoresSafeArea()
        Circle()
          .fill(.blue)
          .opacity(0.3)
          .frame(width: 32, height: 32)
        VStack {
          Spacer()
          Text("location status: \(locationManager.statusString)")
          Text("latitude: \(userLatitude)")
          Text("longitude: \(userLongitude)")
        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

import Foundation
import CoreLocation
//import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
  
  private let locationManager = CLLocationManager()
  @Published var locationStatus: CLAuthorizationStatus?
  @Published var lastLocation: CLLocation?
  @Published var region:MKCoordinateRegion
  @Published var delta: Double
  
//  var loc: CLLocationCoordinate2D {
//    let lat = lastLocation?.coordinate.latitude ?? 0
//    let long = lastLocation?.coordinate.longitude ?? 0
//    return CLLocationCoordinate2D(latitude: lat, longitude: long)
//  }
  
//  var region:MKCoordinateRegion {
//    return MKCoordinateRegion(center: loc, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
//  }

  override init() {
    delta = 0.005
    region = MKCoordinateRegion()
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
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
//    let delta = 0.005
    region = MKCoordinateRegion(center: loc, span: MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta))
    print("locationManager didUpdateLocations", location)
  }
  
}
