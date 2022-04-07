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
    VStack {
      let locations = [userLoc()]
      ZStack {
        Map(coordinateRegion: $locationManager.region, annotationItems: locations) { location in
          MapMarker(coordinate: location.coordinate)
        }
        .ignoresSafeArea()
        //Circle()
        //  .fill(.blue)
        //  .opacity(0.3)
        //  .frame(width: 32, height: 32)
        VStack {
          Spacer()
          HStack {
            Spacer()
            Button(action: homeAction ) {
              Image(systemName: "rectangle")
            }
            .padding()
            .background(.black.opacity(0.75))
            .foregroundColor(.white)
            .font(.title)
            .clipShape(Circle())
//            .padding(.trailing)
          }
        }
        VStack {
          Spacer()
          // Slider(value: $locationManager.delta, in: 0.0005...0.05)
          // Text("location status: \(locationManager.statusString)")
          Text("latitude: \(locationManager.userLatitude)")
          Text("longitude: \(locationManager.userLongitude)")
        }
      }
    }
  }
  
  func homeAction() {
    print("home")
  }
  
  func userLoc() -> Location {
    let center = locationManager.region.center;
    return Location(id: UUID(), latitude: center.latitude, longitude: center.longitude)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

