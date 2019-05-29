//
//  McxPaintPointController.swift
//  BotasMobilApp
//
//  Created by Admin on 17.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import MapKit
class McxPaintPointController :UITapGestureRecognizer{
    private var _point:MKCircle!
    internal let _map:MKMapView = MapHelper.getMap()
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        if(_point == nil){
            return
        }
        
        _map.addAnnotation(_point)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            let coordinate = _map.convert(touch.location(in: _map), toCoordinateFrom: _map)
            _point = MKCircle(center: coordinate, radius: 5.0)
        }
    }
}
