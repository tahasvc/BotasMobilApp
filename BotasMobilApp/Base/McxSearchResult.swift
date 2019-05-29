//
//  McxSearchResult.swift
//  BotasMobilApp
//
//  Created by Admin on 30.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxSearchResult {
    private var featureReader:IMcxFeatureReader?
    private var layer:IMcxLayer?
    func getFeatureReader() -> IMcxFeatureReader {
        return self.featureReader!
    }
    func setFeatureReader(featureReader:IMcxFeatureReader) -> () {
        self.featureReader=featureReader
    }
    func getLayer() -> IMcxLayer {
        return self.layer!
    }
    func setLayer(layer:IMcxLayer) -> () {
        self.layer=layer
    }
}
