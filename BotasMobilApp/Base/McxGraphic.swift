//
//  McxGraphic.swift
//  BotasMobilApp
//
//  Created by Admin on 24.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxGraphic: IMcxGraphic {
    private var _opacity:Double
    private var _size:Float
    private var _color:UIColor
    init(_ size:Float) {
        self._opacity = 1
        self._size = size
        self._color = .red
    }
    func getOpacity() -> Double {
        return self._opacity
    }
    
    func getSize() -> Float {
        return self._size
    }
    
    func setSize(_ size: Float) {
        self._size = size
    }
    
    func getColor() -> UIColor {
        return self._color
    }
    
    func setColor(_ color: UIColor) {
        self._color = color
    }
    func setOpacity(_ opacity: Double) {
        self._opacity = opacity
    }
    
}
