//
//  GpsLocationViewController.swift
//  BotasMobilApp
//
//  Created by Admin on 21.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import MapKit
class GpsLocationViewController:UIViewController ,CLLocationManagerDelegate{
    var locationManager: CLLocationManager!
    private var _coordinate:CLLocationCoordinate2D!
    @IBOutlet weak var xTextBox: UITextField!
    @IBOutlet weak var yTextBox: UITextField!
    @IBOutlet var gpsView: UIView!
    var myTimer:Timer!
    var point:MKPointAnnotation!
    var panGesture = UIPanGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 20
        self.view.subviews[0].isUserInteractionEnabled = true
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
        gpsView.isUserInteractionEnabled = true
        gpsView.addGestureRecognizer(panGesture)
        xTextBox.isUserInteractionEnabled = false
        yTextBox.isUserInteractionEnabled = false
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        // Check for Location Services
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
        
        //Zoom to user location
        if let userLocation = locationManager.location?.coordinate {
            let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation, 200, 200)
            MapHelper.getMap().setRegion(viewRegion, animated: false)
            _coordinate = locationManager.location?.coordinate
            xTextBox.text = String(format: "%f", _coordinate.latitude)
            yTextBox.text = String(format: "%f", _coordinate.longitude)
            point = MKPointAnnotation()
            point.coordinate = _coordinate
            myTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)
            MapHelper.getMap().addAnnotation(point)
        }
        self.locationManager = locationManager
        self.locationManager.stopUpdatingLocation()
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }
    @objc func runTimedCode() {
        MapHelper.getMap().removeAnnotation(point)
    }
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        self.view.bringSubview(toFront: gpsView)
        let translation = sender.translation(in: self.view)
        gpsView.center = CGPoint(x: gpsView.center.x + translation.x, y: gpsView.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
}
