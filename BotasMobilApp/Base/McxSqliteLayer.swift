//
//  McxSqliteLayer.swift
//  BotasMobilApp
//
//  Created by Admin on 17.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import SQLite
class McxSqliteLayer: IMcxLayer {
    private var _dataSource:McxSqliteDataSource!
    private var _name:String!
    private var _tableId:Int = -1
    private var _geometryField:String = "GEOMETRY"
    private var _schema:IMcxSchema!
    private var _keyField:String!
    private var _visible:Bool = true
    private var _coordinateSystem:IMcxCoordinateSystem!
    private var _symbolizer:IMcxSymbolizer!
    
    init(name:String,dataSource:McxSqliteDataSource) {
        _name = name
        _dataSource = dataSource
    }
    func getCoordinateSystem() -> IMcxCoordinateSystem {
        return _coordinateSystem
    }
    
    func getField(ordinal: AnyObject) -> IMcxFieldDefinition {
        return self._schema.getField(name: "")
    }
    
    func getFieldCount() -> Int {
        return self._schema.getFieldCount()
    }
    
    func query(fields: String, whereClause: String, layer: IMcxLayer) -> McxSearchResult? {
        return nil
    }
    func search() ->McxSearchResult {
        return self.search(fields: "", whereClause: "", geometry: nil, relation: "", ajaxParameter: "")!
    }
    func search(fields: String, whereClause: String, geometry: IMcxGeometry?, relation: String, ajaxParameter: String) -> McxSearchResult? {
        let exetuceReader = _dataSource.executeReader(self.getName(),whereClause)
        let reader:IMcxFeatureReader = McxSqliteFeatureReader(layer: self, reader: exetuceReader!)
        let searchResult:McxSearchResult = McxSearchResult()
        searchResult.setFeatureReader(featureReader: reader)
        searchResult.setLayer(layer: self)
        
        return searchResult
    }
    
    func getKeyField() -> String {
        return self._keyField
    }
    
    func setKeyField(keyField: String) {
        self._keyField = keyField
    }
    
    func getGeometryField() -> String {
        return self._geometryField
    }
    
    func setGeometryField(geometryField: String) {
        self._geometryField = geometryField
    }
    
    func getSchema() -> IMcxSchema {
        if self._schema != nil{
            return self._schema
        }
        _schema = McxSchema()
        
        return _schema
    }
    func createEdit() -> IMcxEdit {
        let edit:McxSqliteEdit = McxSqliteEdit(dataSource: self._dataSource, layer: self)
        
        return edit
    }
    func getName() -> String {
        return self._name
    }
    
    func createFeatureBuffer() -> IMcxFeature? {
        return McxMemFeature(layer: self, fieldDefinition: self.getSchema().getFields())
    }
    func search(_ whereClause: String) -> McxSearchResult {
        return search(fields: "", whereClause: whereClause, geometry: nil, relation: "", ajaxParameter: "")!
    }
    func getSymbolizer() -> IMcxSymbolizer {
        return self._symbolizer
    }
    func setSymbolizer(_ symbolizer: IMcxSymbolizer) {
        self._symbolizer = symbolizer
    }
}
