//
//  McxLineSymbolizer.swift
//  BotasMobilApp
//
//  Created by Admin on 24.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxLineSymbolizer: IMcxLineSymbolizer {
    private var _fill:IMcxFill
    private var _stroke:IMcxStroke
    init() {
        self._stroke  = McxStroke()
        self._fill = McxFill()
    }
    func getStroke() -> IMcxStroke {
        return self._stroke
    }
    
    func setStroke(_ stroke: IMcxStroke) {
        self._stroke = stroke
    }
    
    func getFill() -> IMcxFill {
        return self._fill
    }
    
    func setFill(_ fill: IMcxFill) {
        self._fill = fill
    }
    
    
}
