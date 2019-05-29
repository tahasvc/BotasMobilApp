//
//  IMcxFill.swift
//  BotasMobilApp
//
//  Created by Admin on 24.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
protocol IMcxFill {
    func getColor() -> UIColor
    
    func setColor(_ color:UIColor)
    
    func setOpacity(_ opacity:Double)
    
    func getOpacity() -> Double
    
}
