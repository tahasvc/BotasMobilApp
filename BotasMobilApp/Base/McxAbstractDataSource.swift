//
//  McxAbstractDataSource.swift
//  BotasMobilApp
//
//  Created by Admin on 26.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxAbstractDataSource: IMcxDataSource {
    internal var _dataSourceName:String
    internal var _driver:IMcxDriver
    internal var _connectionString:String
    internal var _layerArray:[IMcxLayer]
    internal var _credentials:String
    func getLayer(layerName: String) -> McxGetLayerResult {
        
        return McxGetLayerResult()
    }
    func getLayer(layerName: String) -> IMcxLayer? {
        return nil
    }
    init(driver:IMcxDriver,source:String) {
        self._driver=driver
        self._connectionString=source
        self._dataSourceName=""
        self._credentials=""
        self._layerArray=[IMcxLayer]()
        self.initialize()
    }
    func initialize() -> () {
        let splitConnectionStr = self._connectionString.components(separatedBy: "@")
        var splitString=[String]()
        splitString = splitConnectionStr
        if splitConnectionStr.count > 1 {
            if splitString[2] != nil {
                self._credentials = splitString[2]
            }
        }
        
        if splitConnectionStr.count > 3 {
            self._dataSourceName = splitString[3]
        }
    }
    func add(layer:IMcxLayer) -> () {
        self._layerArray.append(layer)
    }
    func getName() -> String {
        return self._connectionString
    }
}
