//
//  WipicTableViewController.swift
//  Wipic_Plain
//
//  Created by John Dorry on 4/27/16.
//  Copyright © 2016 John Dorry. All rights reserved.
//

import UIKit
import CoreLocation

class WipicTableViewController: UITableViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @available(iOS 9.0, *)
    lazy var locationManager: CLLocationManager! = {
        NSLog("logged in")
        let manager = CLLocationManager()
        manager.desiredAccuracy = 10.0
        manager.distanceFilter = kCLDistanceFilterNone
        manager.delegate = self
        manager.allowsBackgroundLocationUpdates = true
        manager.requestAlwaysAuthorization()
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 9.0, *) {
            locationManager.startUpdatingLocation()
        } else {
            // Fallback on earlier versions
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Get the most recent location
        let location  = locations[locations.count - 1]
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        print("\(latitude),\(longitude)")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Do any additional setup after loading the view.
        if let pImage = Globals.profileImage{
            profileImage.image = pImage
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
