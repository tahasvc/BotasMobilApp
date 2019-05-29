//
//  IMcxPolygonSymbolizer.swift
//  BotasMobilApp
//
//  Created by Admin on 24.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
protocol IMcxPolygonSymbolizer:IMcxSymbolizer {
    func getFill() -> IMcxFill
    
    func setFill(_ fill :IMcxFill)
    
    func getStroke() -> IMcxStroke
    
    func setStroke(_ stroke:IMcxStroke)
    
}
