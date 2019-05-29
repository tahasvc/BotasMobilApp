//
//  IMcxGraphic.swift
//  BotasMobilApp
//
//  Created by Admin on 24.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
protocol IMcxGraphic {
    func getOpacity() -> Double
    
    func setOpacity(_ opacity:Double)
    
    func getSize() -> Float
    
    func setSize(_ size:Float) -> ()
    
    func getColor() -> UIColor
    
    func setColor(_ color :UIColor)
}
