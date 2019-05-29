//
//  McxGetLayerResult.swift
//  BotasMobilApp
//
//  Created by Admin on 25.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxGetLayerResult{
    var _layers = [IMcxLayer]()
    func getLayers() -> [IMcxLayer] {
        return self._layers
    }
    func setLayers(layers:[IMcxLayer]) -> () {
        self._layers=layers
    }
}
