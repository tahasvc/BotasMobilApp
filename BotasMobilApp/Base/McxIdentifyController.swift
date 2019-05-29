//
//  McxIdentiyController.swift
//  BotasMobilApp
//
//  Created by Admin on 27.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import MapKit
class McxIdentifyController: McxPaintPointController {
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            let coordinate = _map.convert(touch.location(in: _map), toCoordinateFrom: _map)
            
            self.intersectCntrl(MKCircle(center: coordinate, radius: 5.0))
        }
    }
    func intersectCntrl(_ infPoint:MKCircle) -> () {
        let layer:IMcxLayer = BotasMobilDataBaseHelper.getLocalSurecLayer()
        let reader:IMcxFeatureReader = layer.search().getFeatureReader()
        while reader.read() {
            let feature:IMcxFeature = reader.getCurrent()
            if feature.getGeometry() == nil{
                continue
            }
            let point = feature.getGeometry() as! MKCircle
            let intersection:Bool = point.intersects(infPoint.boundingMapRect)
            if intersection{
                self.onFeatureSelectSuccess(feature)
            }
        }
        
    }
    func onFeatureSelectSuccess(_ feature:IMcxFeature) -> () {
        let dialog = AddProcessFragment(feature: feature, insertMode: .Update)
        ViewController.delegate.presentDialogViewController(dialog)
    }
}
