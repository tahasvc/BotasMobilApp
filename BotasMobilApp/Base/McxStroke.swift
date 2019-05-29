//
//  McxStroke.swift
//  BotasMobilApp
//
//  Created by Admin on 24.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxStroke: IMcxStroke {
    private var _color:UIColor
    private var _opacity:Double
    private var _width:Float
    
    init() {
        self._color = .blue
        self._opacity = 1
        self._width = 1
    }
    func getColor() -> UIColor {
        return self._color
    }
    
    func setColor(_ color: UIColor) {
        self._color = color
    }
    
    func getOpacity() -> Double {
       return  self._opacity
    }
    
    func setOpacity(_ opacity: Double) {
        self._opacity = opacity
    }
    
    func getWidth() -> Float {
        return self._width
    }
    
    func setWidth(_ width: Float) {
        self._width = width
    }
    
    
}
