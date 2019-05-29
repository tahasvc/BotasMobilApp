//
//  McxSqliteFeatureReader.swift
//  BotasMobilApp
//
//  Created by Admin on 19.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import SQLite
class McxSqliteFeatureReader: IMcxFeatureReader {
    private var _layer:IMcxLayer
    private var _reader:Statement
    private var _item:Statement.Element!
    init(layer:IMcxLayer,reader:Statement) {
        _layer = layer
        _reader = reader
    }
    func read() -> Bool {
        let item = _reader.next()
        if(item == nil){
            return false
        }
        _item = item
        
        return true
    }
    
    func getCurrent() -> IMcxFeature {
        let feature:IMcxFeature = McxMemFeature(layer: _layer, fieldDefinition: _layer.getSchema().getFields())
        for i in 0..<_layer.getSchema().getFieldCount(){
            let field:IMcxFieldDefinition = _layer.getSchema().getFields()[i]
            let value = _item[i]
            if value == nil{
                continue
            }
            if(field.getFieldName() == _layer.getKeyField()){
                feature.setFeatureId(featureId: Int(value as! Int64))
                continue
            }
            if field.getFieldType() == McxDataTypeCode.IMcxGeometry {
                let helper = McxFeatureWktHelper(value as! String)
                let geometry = helper.createFromWkb()
                if(geometry != nil){
                   feature.setGeometry(geometry: geometry!)
                }
                continue
            }
            feature.setValue(ordinalOrName: field.getFieldName() as AnyObject, value: value as AnyObject)
        }
        
        return feature
    }
}
