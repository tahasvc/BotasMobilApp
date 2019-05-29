//
//  McxFsFeatureReader.swift
//  BotasMobilApp
//
//  Created by Admin on 29.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import MapKit
class McxFsFeatureReader:IMcxFeatureReader{
    private var _featureString:String
    private var _coordinateSystem:IMcxCoordinateSystem?
    private var _attributeFilter:String
    private var _layer:IMcxLayer
    private var _stringCursor:Int
    private var _currentFeature:IMcxFeature?
    private var _numberOfFeature:Double!
    private var _numberOfFields:Double?
    private var _filterArray:[String]?
    private var _passedFeatures:Int = 0
    private var transformed:Bool = false
    
    // world IMcxEnvelope display RectangleF(ios tarafında ne varsa) olarak change edilecek
    init(featureString:String,fields:String,layer:IMcxLayer,world:String,display:String) {
        var _fields:String = ""
        self._featureString=featureString
        self._coordinateSystem=nil
        self._attributeFilter=_fields
        self._layer=layer
        self._stringCursor=1
        self._numberOfFeature=0
        transformed = self._layer.getCoordinateSystem().getAuthorityCode() == "3857"
        if(layer != nil){
            //            self._coordinateSystem = layer.getCoordinateSystem()
        }
        
        if(fields != ""){
            _fields = fields.replacingOccurrences(of: " ", with: "")
        }
        
        self.initialize()
    }
    func initialize() -> () {
        if(self._featureString.count != 0){
            self._numberOfFeature = readInteger(delimiter: ";")
        }
        
        self._numberOfFields = 0
        if(self._numberOfFeature != 0 && self._featureString.count != 0){
            self._numberOfFields = readInteger(delimiter: ";")
        }
        
        if(self._attributeFilter != ""){
            self._filterArray = self._attributeFilter.components(separatedBy: ",")
        }else{
            self._filterArray = [String]()
            for i in 0..<_layer.getFieldCount(){
                var field:IMcxFieldDefinition = _layer.getField(ordinal: i as AnyObject)
                self._filterArray?.append(field.getFieldName())
            }
        }
        self._passedFeatures = 0
    }
    func readInteger(delimiter:Character) -> Double {
        return Double(self.readNext(delimiter: delimiter))!
    }
    func readNext(delimiter:Character) -> String {
        var temp:String = ""
        while self._stringCursor < self._featureString.count {
            let charAt = self._featureString.charAt(at: self._stringCursor)
            if(charAt == delimiter){
                self._stringCursor+=1
                break
            }else{
                temp += String(self._featureString.charAt(at: self._stringCursor))
                self._stringCursor+=1
            }
        }
        return temp
    }
    func read() -> Bool {
        if(self._numberOfFeature == 0){
            return false
        }
        
        if(Double(self._passedFeatures) >= self._numberOfFeature){
            return false
        }
        
        self.readFeature()
        
        return true
    }
    func readFeature() -> () {
        self._currentFeature = McxMemFeature(layer: self._layer,fieldDefinition:nil)
        var numberOfFields:Int = 0
        while(self._stringCursor < self._featureString.count){
            let filter:String = self._filterArray![numberOfFields]
            let field:IMcxFieldDefinition = self._layer.getField(ordinal: filter as AnyObject)
            if(field == nil){
                return
            }
            
            numberOfFields += 1
            var fieldName:String = field.getFieldName().uppercased()
            fieldName = fieldName.replacingOccurrences(of: "İ", with: "I")
            switch fieldName{
            case "GEOMETRY":
                self._currentFeature?.setGeometry(geometry: self.parseGeometry()!)
            case "FEATUREID":
                self._currentFeature?.setFeatureId(featureId: Int(self.parseKeyField()))
            default:
                var value:AnyObject = self.parseDefault() as AnyObject
                let fieldType:McxDataTypeCode = field.getFieldType()
                if(McxDataTypeCode.Double == fieldType){
                    if(value as! String == ""){
                        value = Double(value as! String) as AnyObject
                    }else{
                        value = 0 as AnyObject
                    }
                }
                
                if ((McxDataTypeCode.Float == fieldType || McxDataTypeCode.Int64 == fieldType || McxDataTypeCode.Int16 == fieldType) && value as! String != "") {
                    value = Int(value as! String) as AnyObject
                }
                
                if McxDataTypeCode.Int32 == fieldType && value as! String != ""{
                    value = Int((value as! String), radix:10) as AnyObject
                }
                
                if String(describing: value) == "0"{
                    self._currentFeature?.setValue(ordinalOrName: field.getFieldName() as AnyObject, value: value)
                }else if value as? Bool == false {
                    self._currentFeature?.setValue(ordinalOrName: field.getFieldName() as AnyObject, value: "" as AnyObject)
                }else{
                    self._currentFeature?.setValue(ordinalOrName: field.getFieldName() as AnyObject, value: value)
                }
            }
            
            if(field.getFieldName() == self._layer.getGeometryField()){
                self._stringCursor += 1
            }
            
            if(Int(self._numberOfFields!) == numberOfFields){
                break
            }
        }
        self._passedFeatures += 1
    }
    
    func parseGeometry() -> MKAnnotation? {
        if(self._featureString.charAt(at: self._stringCursor) == ";"){
            return nil
        }
        
        let geometryTypeInt:Int = Int(self.readInteger(delimiter: " "))
        var geometryType:McxGeometryType = McxGeometryType.fromInteger(geometryTypeValue: geometryTypeInt)
        let epsgCode:Double = self.readInteger(delimiter: " ")
        //        var geometry:IMcxGeometry? = nil
        var geometry:MKAnnotation? = nil
        switch geometryType {
        case .Point:
            geometry = self.parsePoint()
        case .LineString:
            geometry = self.parseLineString()
        case .Polygon:
            geometry = self.parsePolygon()
        case .MultiLineString:
            geometry = self.parseLineString()
        default:
            geometry = nil
        }
        return geometry!
    }
    func parsePoint() -> IMcxPoint {
        var x:Double = self.readInteger(delimiter: " ")
        var y:Double = self.readInteger(delimiter: " ")
        var geom:IMcxGeometry?=nil
        return geom as! IMcxPoint
    }
    func parsePoint() -> MKCircle {
        let x:Double = Double(self.readInteger(delimiter: " "))
        let y:Double = Double(self.readInteger(delimiter: " "))
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: x, longitude: y).transform()
        var point:MKCircle? = nil
        if self.transformed{
            point = MKCircle(center: coordinate, radius: 5.0)
        }
        return point!
    }
    func parseLineString() -> IMcxLineString {
        var geom:IMcxGeometry?=nil
        return geom as! IMcxLineString
    }
    func parseLineString() -> MKPolyline {
        let numberOfPoints:Int = Int(self.readInteger(delimiter: " "))
        var points = [CLLocationCoordinate2D]()
        for i in 0..<numberOfPoints{
            let point:MKCircle = self.parsePoint()
            points.append(point.coordinate)
        }
        return MKPolyline(coordinates: points, count: points.count)
    }
    func parsePolygon() -> IMcxPolygon{
        var geom:IMcxGeometry?=nil
        return geom as! IMcxPolygon
    }
    func parsePolygon() -> MKPolygon{
        let numberOfParts:Int = Int(self.readInteger(delimiter: " "))
        let numberOfPoints:Int = Int(self.readInteger(delimiter: " "))
        var points = [CLLocationCoordinate2D]()
        
        for i in 0..<numberOfPoints{
            let point:MKCircle = self.parsePoint()
            points.append(point.coordinate)
        }
        return MKPolygon(coordinates: points, count: points.count)
    }
    func parseKeyField() -> Double {
        return self.readInteger(delimiter: ";")
    }
    func parseDefault() -> String {
        return self.readNext(delimiter: ";")
    }
    func getCurrent() -> IMcxFeature {
        return self._currentFeature!
    }
    
}
extension String {
    func charAt(at: Int) -> Character {
        let charIndex = self.index(self.startIndex, offsetBy: at)
        return self[charIndex]
    }
}
extension CLLocationCoordinate2D{
    func transform() ->CLLocationCoordinate2D {
        let b = 20037508.34;
        var lon = self.latitude;
        var lat = self.longitude;
        lon = lon * 180 / b;
        lat = atan(exp(lat * Double.pi / b)) * 360 / Double.pi - 90;
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        return coord
    }
    
}
