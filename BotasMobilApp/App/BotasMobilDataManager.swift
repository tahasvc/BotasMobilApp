//
//  BotasMobilDataManager.swift
//  BotasMobilApp
//
//  Created by Admin on 14.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class BotasMobilDataManager {
    private var _source:String!
    private var _dataSource:IMcxDataSource!
    
    init(_ source:String) {
        _source = source
        _dataSource = self.getDataSource()
    }
    func getDataSource() -> IMcxDataSource {
        if _dataSource != nil{
            return _dataSource
        }
        
        var dataSource:IMcxDataSource?=nil
        let fsDriver:McxFsDriver = McxFsDriver()
        do {
            let dataSourceResult:McxOpenDataSourceResult = fsDriver.openDataSource(source: _source)
            dataSource = dataSourceResult.getDataSource()
            
        } catch{
            
        }
        return dataSource!
    }
    func getLayer(_ layer:String) -> IMcxLayer {
        return _dataSource.getLayer(layerName: layer)._layers[0]
    }
}
