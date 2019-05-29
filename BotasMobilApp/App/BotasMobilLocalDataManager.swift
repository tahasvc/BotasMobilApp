//
//  BotasMobilLocalDataManager.swift
//  BotasMobilApp
//
//  Created by Admin on 14.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class BotasMobilLocalDataManager {
    private var _source:String!
    private var _targetDataSource:IMcxDataSource!
    private var _driver:McxSqliteDriver = McxSqliteDriver()
    private var _sourceName:String!
    public static var isOpen = false
    func setDataSource(_ source:String) -> () {
        self._source = source
        _targetDataSource = _driver.openDataSource(source: _source)
    }
    func getDataSourceString() -> String {
        return self._source
    }
    func getDataSource() -> IMcxDataSource{
        return _targetDataSource
    }
    func getLayer(layerName:String) -> IMcxLayer {
        var layer:McxSqliteLayer?=nil
        layer  = _targetDataSource?.getLayer(layerName: layerName) as! McxSqliteLayer
        
        return layer!
    }
    func setSourceName(_ name:String) {
        _sourceName = name
    }
}
