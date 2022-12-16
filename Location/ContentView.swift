//
//  ContentView.swift
//  Location
//
//  Created by jht2 on 4/5/22.
//

import SwiftUI
import MapKit

struct Location: Identifiable, Codable, Equatable {
  let id: UUID
  let latitude: Double
  let longitude: Double
  var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}

struct ContentView: View {
  
  @StateObject var locationManager = LocationManager()
  
  var body: some View {
    ZStack {
      Map(coordinateRegion: $locationManager.region,
          annotationItems: locations())
      { location in
        MapMarker(coordinate: location.coordinate)
      }
      .ignoresSafeArea()
      Circle()
        .fill(.blue)
        .opacity(0.3)
        .frame(width: 32, height: 32)
      VStack {
        Spacer()
        HStack {
          Spacer()
          Button(action: centerUserLocationAction ) {
            Image(systemName: "star")
          }
          .padding()
          .background(.black.opacity(0.75))
          .foregroundColor(.white)
          .font(.title)
          .clipShape(Circle())
        }
      }
      VStack {
        Spacer()
        // Slider(value: $locationManager.delta, in: 0.0005...0.05)
        // Text("location status: \(locationManager.statusString)")
        Text("lat: \(locationManager.centerLatitude)")
        Text("lon: \(locationManager.centerLongitude)")
      }
    }
  }
  
  func centerUserLocationAction() {
    withAnimation {
      locationManager.centerUserLocation()
    }
  }
  
  func locations() -> [Location] {
    if let last = locationManager.lastLocation {
      let center = last.coordinate
      return [Location(id: UUID(), latitude: center.latitude, longitude: center.longitude)]
    }
    return []
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}


