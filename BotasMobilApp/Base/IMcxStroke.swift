//
//  IMcxStroke.swift
//  BotasMobilApp
//
//  Created by Admin on 24.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
protocol IMcxStroke {
    func getColor() -> UIColor
    
    func setColor(_ color :UIColor)
    
    func getOpacity() -> Double
    
    func setOpacity(_ opacity:Double)
    
    func getWidth() -> Float
    
    func setWidth(_ width:Float) -> ()
    
}
