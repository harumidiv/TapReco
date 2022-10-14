//
//  LocationManager.swift
//  TapReco
//
//  Created by 佐川 晴海 on 2022/10/14.
//

import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    let geocoder = CLGeocoder()
    var address: String?

    static let shared = LocationManager()

    private let locationManager: CLLocationManager

    private override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus

        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.allowsBackgroundLocationUpdates = false //バックグラウンドでは取得しないのでfalse
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startUpdatingLocation()
    }

    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.geocoder.reverseGeocodeLocation( location, completionHandler: { ( placemarks, error ) in
                if let placemark = placemarks?.first {
                    //住所の取得
                    let administrativeArea = placemark.administrativeArea == nil ? "" : placemark.administrativeArea!
                    let locality = placemark.locality == nil ? "" : placemark.locality!
                    let subLocality = placemark.subLocality == nil ? "" : placemark.subLocality!
                    let thoroughfare = placemark.thoroughfare == nil ? "" : placemark.thoroughfare!
                    let subThoroughfare = placemark.subThoroughfare == nil ? "" : placemark.subThoroughfare!
                    let placeName = !thoroughfare.contains( subLocality ) ? subLocality : thoroughfare
                    self.address = administrativeArea + locality + placeName + subThoroughfare
                    print("address: \(self.address)")
                }
            } )
        }

    }
}
