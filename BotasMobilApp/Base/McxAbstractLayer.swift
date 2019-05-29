//
//  McxAbstractLayer.swift
//  BotasMobilApp
//
//  Created by Admin on 29.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxAbstractLayer: IMcxLayer {
    internal var _name:String
    internal var _alias:String
    private var _keyField:String
    internal var _layerName:String
    internal var fullName:String
    internal var _coordinateSystem:IMcxCoordinateSystem?
    private var _dataSource:IMcxDataSource
    internal var fieldDefinitionArray:[IMcxFieldDefinition]
    internal var fieldGuid:String?
    internal var _geometryField:String
    
    init(dataSource:IMcxDataSource,name:String) {
        self._name = name
        self._dataSource = dataSource
        self._layerName = name
        self._keyField=""
        self._alias=""
        self.fullName=name
        self._geometryField=""
        self.fieldDefinitionArray = [IMcxFieldDefinition]()
    }
    
    func getCoordinateSystem() -> IMcxCoordinateSystem {
        return self._coordinateSystem!
    }
    
    func getField(ordinal: AnyObject) -> IMcxFieldDefinition {
        if ordinal is String{
            for i in 0..<self.fieldDefinitionArray.count{
                if(ordinal as! String == self.fieldDefinitionArray[i].getFieldName()){
                    return self.fieldDefinitionArray[i]
                }
            }
            
        }else if(ordinal is Int){
            return self.fieldDefinitionArray[(ordinal as? Int)!]
            
        }
        return self.fieldDefinitionArray[0]
    }
    
    func createField(fieldDefinition:IMcxFieldDefinition){
        self.fieldDefinitionArray.append(fieldDefinition)
    }
    
    func getFieldCount() -> Int {
        return self.fieldDefinitionArray.count
    }
    func setGeometryField(geometryField:String) -> () {
        self._geometryField=geometryField
    }
    func getGeometryField() -> String {
        return self._geometryField
    }
    func getKeyField() -> String {
        return self._keyField
    }
    func setKeyField(keyField:String) -> () {
        self._keyField = keyField
    }
    func query(fields: String, whereClause: String, layer: IMcxLayer) -> McxSearchResult? {
        return McxSearchResult()
    }
    
    func search(fields: String, whereClause: String, geometry: IMcxGeometry?, relation: String, ajaxParameter: String) -> McxSearchResult? {
        return McxSearchResult()
    }
    
    func getSchema() -> IMcxSchema {
        return McxSchema()
    }
    
    func createEdit() -> IMcxEdit {
        return McxSqliteEdit(dataSource: _dataSource as! McxSqliteDataSource, layer: self)
    }
    
    func getName() -> String {
        return self._layerName
    }
    func createFeatureBuffer() -> IMcxFeature? {
        return nil
    }
    func search() -> McxSearchResult {
        return self.search(fields: "", whereClause: "", geometry: nil, relation: "", ajaxParameter: "")!
    }
    func search(_ whereClause: String) -> McxSearchResult {
        return self.search(fields: "", whereClause: whereClause, geometry: nil, relation: "", ajaxParameter: "")!
    }
    func getFullName() -> String {
        return self.fullName
    }
    func getSymbolizer() -> IMcxSymbolizer {
        
        return McxPointSymbolizer()
    }
    func setSymbolizer(_ symbolizer: IMcxSymbolizer) {
        
    }
}
