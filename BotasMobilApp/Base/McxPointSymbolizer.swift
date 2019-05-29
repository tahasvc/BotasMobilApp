//
//  McxPointSymbolizer.swift
//  BotasMobilApp
//
//  Created by Admin on 24.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxPointSymbolizer: IMcxPointSymbolizer {
    private var _graphic:IMcxGraphic
    private var _opacity:Double = 1
    private var _stroke:IMcxStroke!
    
    init() {
        _graphic = McxGraphic(1)
        _stroke = McxStroke()
    }
    func getGraphic() -> IMcxGraphic {
        return self._graphic
    }
    
    func setGraphic(_ graphic: IMcxGraphic) {
        _graphic = graphic
    }
    
    func getStroke() -> IMcxStroke {
        return self._stroke
    }
    
    func setStroke(_ stroke: IMcxStroke) {
        self._stroke = stroke
    }
    
}
