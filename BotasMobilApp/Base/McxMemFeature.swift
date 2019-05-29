//
//  McxMemFeature.swift
//  BotasMobilApp
//
//  Created by Admin on 2.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import MapKit
class McxMemFeature: IMcxFeature {
    
    private var _layer:IMcxLayer
    //    private var _changedValues yazılacak
    private var _values = Dictionary<AnyHashable,McxFieldPair>()
    
    private var _keyField:String
    
    private var _geometryField:String
    
    init(layer:IMcxLayer,fieldDefinition:[IMcxFieldDefinition]?) {
        self._layer=layer
        self._keyField = self._layer.getKeyField()
        self._geometryField = self._layer.getGeometryField()
        self.initialize(fieldDefinitions: fieldDefinition)
    }
    
    func setGeometry(geometry: MKAnnotation) {
        (self._values[self._layer.getGeometryField()])?.setValue(value: geometry as AnyObject)
    }
    
    func getGeometry() -> MKAnnotation? {
        if(self._values[self._geometryField]?.getValue() is NSNull){
            return nil
        }
        return self._values[self._geometryField]?.getValue()as! MKAnnotation
    }
    func getValue(name: String) -> AnyObject {
        let s:AnyObject = "2" as AnyObject
        
        return s
    }

    func initialize(fieldDefinitions:[IMcxFieldDefinition]?) -> () {
        if(fieldDefinitions == nil){
            let fieldCount:Int = self._layer.getFieldCount()
            for i in 0..<fieldCount{
                let field:IMcxFieldDefinition = self._layer.getField(ordinal: i as AnyObject)
                let pair:McxFieldPair = McxFieldPair(fieldDefinition: field,value: NSNull())
                self._values[field.getFieldName()] = pair
            }
        }else{
            for i in 0..<(fieldDefinitions?.count)!{
                let definition:IMcxFieldDefinition = fieldDefinitions![i]
                let pair:McxFieldPair = McxFieldPair(fieldDefinition: definition, value: NSNull())
                self._values[definition.getFieldName()] = pair
            }
        }
    }
    func getLayer() -> IMcxLayer {
        return self._layer
    }
    
    func getValueWithName(name: String) -> AnyObject {
        let pair:McxFieldPair = self._values[name]!
        
        return pair.getValue()
    }
    
    func setValue(ordinalOrName: AnyObject, value: AnyObject) {
        (self._values[ordinalOrName as! AnyHashable] as! McxFieldPair).setValue(value: value)
    }
    func setFeatureId(featureId:Int) -> () {
        self._values[self._keyField]?.setValue(value: featureId as AnyObject)
    }
    func getFeatureId() -> Int {
        return (self._values[self._keyField])?.getValue() as! Int
    }
    func getFieldCount() -> Int {
        return self._values.count
    }
    func getFieldName(ordinal:Int) -> String {
        return Array(self._values.keys)[ordinal].description
    }
    func getField(ordinalName: AnyObject) -> IMcxFieldDefinition {
        var name = ordinalName
        if ordinalName is Int {
            name = self.getFieldName(ordinal:Int(ordinalName as! NSNumber)) as AnyObject
        }
        let pair:McxFieldPair = self._values[name as! String]!
        
        return pair.getFieldDefinition()
    }
    func convertToString(_ filterArray: [String]?) -> String {
        var featureString:String = ""
        for i in 0..<self._layer.getFieldCount() {
            let fieldDefinition:IMcxFieldDefinition = self._layer.getField(ordinal: i as AnyObject)
            if filterArray != nil {
                var find:Bool = false
                for j in 0..<filterArray!.count {
                    var filter:String = String(filterArray![j])
                    if filter == fieldDefinition.getFieldName(){
                          find = true
                        break
                    }
                  
                }
                if(!find){
                    continue
                }
            }
            
            var fieldValue:String =  ""
            let val = self.getValueWithName(name: fieldDefinition.getFieldName())
            if !(val is NSNull) {
                if val is String{
                    fieldValue = val as! String
                }
                else if val is Int{
                    fieldValue = String(val as!Int)
                }
            }
            
            if fieldValue  == nil || fieldValue == "" {
                fieldValue == "null"
            }
            if(self.getFieldName(ordinal: i) == "GEOMETRY" || self.getFieldName(ordinal: i) == "geometry"){
                let converter:McxFeatureWktConverter = McxFeatureWktConverter()
                converter.parseGeometry(geometry: self.getValueWithName(name: self.getFieldName(ordinal: i)) as! MKAnnotation)
            }
            if(val == nil){
                fieldValue = ""
            }
            
            featureString += fieldValue + ";"
        }
        
        return featureString
    }
}
