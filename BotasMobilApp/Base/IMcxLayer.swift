//
//  IMcxLayer.swift
//  BotasMobilApp
//
//  Created by Admin on 25.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

protocol IMcxLayer {
    func getCoordinateSystem() -> IMcxCoordinateSystem
    func getSchema() -> IMcxSchema
    
    func createEdit() -> IMcxEdit 
    
    func getField(ordinal:AnyObject) -> IMcxFieldDefinition
    
    func getFieldCount() -> Int
    
    func query(fields:String,whereClause:String,layer:IMcxLayer) -> McxSearchResult?
    
    func search(fields:String,whereClause:String,geometry:IMcxGeometry?,relation:String,ajaxParameter:String) -> McxSearchResult?
    
    func search() -> McxSearchResult
    
    func search(_ whereClause:String) -> McxSearchResult 
    
    func getKeyField() -> String
    
    func setKeyField(keyField:String) -> ()
    
    func getGeometryField() -> String
    
    func setGeometryField(geometryField:String)
    
    func getName() -> String
    
    func createFeatureBuffer() -> IMcxFeature?
    
    func getSymbolizer() -> IMcxSymbolizer
    
    func setSymbolizer(_ symbolizer:IMcxSymbolizer)
}
