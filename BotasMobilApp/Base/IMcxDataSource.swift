//
//  IMcxDataSource.swift
//  BotasMobilApp
//
//  Created by Admin on 25.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
protocol IMcxDataSource {
    func getLayer(layerName:String) -> McxGetLayerResult
    
    func getLayer(layerName:String) -> IMcxLayer?
    
    func getName() -> String
}
