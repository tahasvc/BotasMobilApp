//
//  BotasMobilCreateController.swift
//  BotasMobilApp
//
//  Created by Admin on 10.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import MapKit
import LSDialogViewController
class BotasMobilCreateController:McxPaintPointController {
    private var _layer:IMcxLayer?
    init(layer:IMcxLayer?) {
        self._layer = layer
        super.init(target: nil, action: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
       
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            let coordinate = MapHelper.getMap().convert(touch.location(in: MapHelper.getMap()), toCoordinateFrom: MapHelper.getMap())
            BotasMobilHelper.createTaskGeometry(coordinate: coordinate)
        }
    
    }
}
