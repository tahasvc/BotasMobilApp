//
//  McxFill.swift
//  BotasMobilApp
//
//  Created by Admin on 24.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxFill: IMcxFill {
    private var _color :UIColor
    private var _opacity:Double
    
    init() {
        self._color = .blue
        self._opacity = 1
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
    
    func getOpacity() -> Double {
        return self._opacity
    }
    
    
}
