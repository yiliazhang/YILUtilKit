//
//  LocationManager.swift
//  clw
//
//  Created by apple on 2016/10/19.
//  Copyright © 2016年 Datang. All rights reserved.
//

import UIKit
import CoreLocation
public protocol LocationManagerDelegate {
    func locationToolLocationServicesDisabled()
    
    func locationToolLocationServicesAuthorizationStatusDenied()
    
    func locationToolLocationServicesAuthorizationStatusAuthorized()
    
    func locationToolLocationServicesLocating()
    
    func locationToolLocationSuccess()
    
    func locationToolLocationFailed()
}

public class YILLocationManager: NSObject {
    struct Constants {
        static let YXWeatherAutoLocation = "weatherAutoLocation"
        static let YXWeatherCurrentLocationCity = "weatherCurrentLocationCity"
        static let YXWeatherCurrentLocationState = "weatherCurrentLocationState"
        static let YXWeatherCurrentLocationLongitude = "weatherCurrentLocationLongitude"
        static let YXWeatherCurrentLocationLatitude = "weatherCurrentLocationLatitude"
    }
    
    public var delegate: LocationManagerDelegate?
//    var isAutoLocation = false
//    var currentLocationCity = ""
//    var currentLocationState = ""
//    var currentLocationLongitude: Int!
//    var currentLocationLatitude: Int!
    
    public var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.distanceFilter = 10.0
        return manager
    }()
    
    public var location: CLLocation?
    
    public static let shared = YILLocationManager()
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func beginLocation() {
        if !CLLocationManager.locationServicesEnabled() {
            YILLocationManager.shared.isAutoLocation = false
            if let delegate = delegate {
                delegate.locationToolLocationServicesDisabled()
            }
            return
        }
        if #available(iOS 8.0, *) {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
            case .restricted, .denied:
                YILLocationManager.shared.isAutoLocation = false
                if let delegate = delegate {
                    delegate.locationToolLocationServicesAuthorizationStatusDenied()
                }
            case .authorizedAlways, .authorizedWhenInUse:
                
                if let delegate = delegate {
                    delegate.locationToolLocationServicesAuthorizationStatusAuthorized()
                }
                if YILLocationManager.shared.isAutoLocation {
                    self.locationManager.startUpdatingLocation()
                }
            }
        } else {
            if let delegate = delegate {
                delegate.locationToolLocationServicesAuthorizationStatusAuthorized()
            }
            if YILLocationManager.shared.isAutoLocation {
                self.locationManager.startUpdatingLocation()
            }
        }
    }
    
    public func getAddress() {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location!) { [weak self](placemarks, error) in
            guard error == nil else {
                if let delegate = self?.delegate {
                    delegate.locationToolLocationFailed()
                }
                return
            }
            let placemark = placemarks!.first!
            let location = placemark.location
//            let addressDic = placemark.addressDictionary
            self?.currentLocationLongitude = (Int(location!.coordinate.longitude))
            self?.currentLocationLatitude = (Int(location!.coordinate.latitude))
            var state = placemark.administrativeArea
            var cityname = placemark.locality!
//            var cityid: String = ""
            var isChinese = true
            for character in cityname {
                if 0x4e00 < character.hashValue && character.hashValue < 0x9fff {
                    isChinese = true
                }
            }
            if isChinese {
                
                state = state?.substring(to: cityname.index(cityname.startIndex, offsetBy: cityname.count - 1))
                cityname = cityname.substring(to: cityname.index(cityname.startIndex, offsetBy: cityname.count - 1))
//                cityid = WeatherManager.cityIDOf(cityname)
            }
//            HSLog("addressDic: %@", addressDic)
//            HSLog("cityid: %@", cityid)
//            HSLog("cityname: %@", cityname)
//            HSLog("state: %@", state)
            if !(cityname == YILLocationManager.shared.currentLocationCity) {
                YILLocationManager.shared.currentLocationCity = cityname
                YILLocationManager.shared.currentLocationState = state!
                
                if let delegate = self?.delegate {
                    delegate.locationToolLocationSuccess()
                }
            }
        }
    }
    
    
    public func resetLocation() {
        self.location = nil
    }
    
    
    public var isAutoLocation: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.YXWeatherAutoLocation)
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.YXWeatherAutoLocation)
            UserDefaults.standard.synchronize()
        }
    }
    
    public var currentLocationCity: String? {
        get {
            return UserDefaults.standard.object(forKey: Constants.YXWeatherCurrentLocationCity) as? String
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.YXWeatherCurrentLocationCity)
            UserDefaults.standard.synchronize()
        }
    }
    
    public var currentLocationState: String {
        get {
            return UserDefaults.standard.object(forKey: Constants.YXWeatherCurrentLocationState) as! String
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.YXWeatherCurrentLocationState)
            UserDefaults.standard.synchronize()
        }
    }
    
    public var currentLocationLongitude: Int {
        get {
            return Int(UserDefaults.standard.integer(forKey: Constants.YXWeatherCurrentLocationLongitude))
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.YXWeatherCurrentLocationLongitude)
            UserDefaults.standard.synchronize()
        }
    }
    
    public var currentLocationLatitude: Int {
        get {
            return Int(UserDefaults.standard.integer(forKey: Constants.YXWeatherCurrentLocationLatitude))
        }
        
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.YXWeatherCurrentLocationLatitude)
            UserDefaults.standard.synchronize()
        }
    }
}

extension YILLocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        HSLog("LocationManager didChangeAuthorizationStatus %zd", status)
        switch status {
        case .notDetermined, .restricted:
            break
        case .denied:
            YILLocationManager.shared.isAutoLocation = false
            YILLocationManager.shared.currentLocationCity = nil
            if let delegate = delegate {
                delegate.locationToolLocationServicesAuthorizationStatusDenied()
            }
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            YILLocationManager.shared.isAutoLocation = true
            self.locationManager.startUpdatingLocation()
            if let delegate = self.delegate {
                delegate.locationToolLocationServicesLocating()
            }
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if location != nil {
            self.locationManager.stopUpdatingLocation()
            return
        }
        location = locations.first!
        self.getAddress()
    }
}
