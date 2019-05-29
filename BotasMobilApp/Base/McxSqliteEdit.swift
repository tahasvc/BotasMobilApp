//
//  McxSqliteEdit.swift
//  BotasMobilApp
//
//  Created by Admin on 17.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import SQLite
protocol TypeOf {
    func type<T, Metatype>(of value: T) -> Metatype
}
class McxSqliteEdit: IMcxEdit {
    private var _dataSource:McxSqliteDataSource!
    private var _layer:IMcxLayer!
    init(dataSource:McxSqliteDataSource,layer:IMcxLayer) {
        _layer=layer
        _dataSource=dataSource
    }
    func insert(_ feature: IMcxFeature) {
        var expressibles:[Expressible] = [Expressible]()
        var setters:[Setter]  = [Setter]()
        var cmdText:String  = ""
        var insertColumns:String = ""
        var insertValues:String = ""
        
        for i in 0..<feature.getFieldCount(){
            let fieldName:String = feature.getFieldName(ordinal: i)
            let featureValue = feature.getValueWithName(name: fieldName)
            let fieldType:McxDataTypeCode = feature.getField(ordinalName: i as AnyObject).getFieldType()
            if feature.getFieldName(ordinal: i) == "FEATUREID"{
                continue
            }
            
            insertColumns.append(fieldName + ",")
            if fieldType == McxDataTypeCode.IMcxGeometry{
                let geometry = feature.getGeometry()
                let converter = McxFeatureWktConverter()
                let geometriStr:String = converter.parseGeometry(geometry: geometry!)
                insertValues.append("'" + geometriStr + "',")
            }else if fieldType == McxDataTypeCode.Guid{
                if featureValue != nil && !(featureValue is NSNull){
                    var globald:String = (featureValue as! String)
                    insertValues.append("'" + globald + "',")
                }
                else{
                    insertValues.append("'',")
                }
            }else if fieldType == McxDataTypeCode.DateTime{
                if (featureValue != nil && !(featureValue is NSNull)){
                    if(featureValue is String){
                       var date = (featureValue as! String)
                        insertValues.append("'" + (date).replacingOccurrences(of: "\\", with: "") + "',")
                    }
                    else if(featureValue is Date){
                        var date = featureValue as! Date
                        insertValues.append("'" + (date.datatypeValue).replacingOccurrences(of: "\\", with: "") + "',")
                    }
                }else{
                    insertValues.append("'',")
                }
            }
            else if fieldType == McxDataTypeCode.Int32{
                var insertValue:String = ""
                if(featureValue is NSNull){
                    insertValue = ""
                }
                else if featureValue is  String{
                    if !(String(featureValue as! String).isEmpty)
                    {
                        insertValue.append(String(featureValue as! String))
                    }
                    
                }
                else if featureValue is Int {
                    if !(String(featureValue as! Int).isEmpty)
                    {
                        insertValue.append(String(featureValue as! Int))
                    }
                }
                
                if insertValue == ""{
                    insertValue = "''"
                }
                
                insertValues.append("" + insertValue + ",")
            }else{
                if featureValue is NSNull {
                    insertValues.append("'',")
                }
                else{
                    if featureValue is Double{
                        insertValues.append("'" + String(featureValue as! Double) + "',")
                    }
                    else{
                        insertValues.append("'" + (featureValue as! String) + "',")
                    }
                    
                }
            }
        }
        
        insertColumns = insertColumns[0..<(insertColumns.count-1)]
        insertValues = insertValues[0..<(insertValues.count-1)]
        cmdText = String(format: "INSERT INTO %@ (%@) VALUES (%@) ;", _layer.getName(),insertColumns,insertValues)
        _dataSource.executeNonQuery(cmdText.unescaped)
        //        let insertScrpt = Table(_layer.getName()).insert(setters)
        //        _dataSource.executeNonQuery(insertSql:insertScrpt)
    }
    //    func insert(_ feature: IMcxFeature) {
    //        var expressibles:[Expressible] = [Expressible]()
    //        var setters:[Setter]  = [Setter]()
    //        for i in 0..<feature.getFieldCount(){
    //            let fieldName:String = feature.getFieldName(ordinal: i)
    //            let featureValue = feature.getValueWithName(name: fieldName)
    //            let fieldType:McxDataTypeCode = feature.getField(ordinalName: i as AnyObject).getFieldType()
    //            if feature.getFieldName(ordinal: i) == "FEATUREID"{
    //                if feature.getValueWithName(name: feature.getFieldName(ordinal: i)) == nil{
    //                    continue
    //                }
    //            }
    //            var setter:Setter? = nil
    //            if featureValue is String {
    //                if(featureValue as! String == ""){
    //                    continue
    //                }
    //            }
    //            if featureValue == nil || featureValue is NSNull
    //            {
    //                continue
    //            }
    //            switch fieldType{
    //
    //            case .Boolean:
    //                setter = (Expression<Bool>(fieldName) <- featureValue as! Bool)
    //            case .Byte:
    //                setter = (Expression<Int64>(fieldName) <- Int64(featureValue as! String)!)
    //            case .Int16:
    //                setter = (Expression<Int64>(fieldName) <- Int64(featureValue as! Int16))
    //
    //            case .Int32:
    //                if(featureValue is Int32 || featureValue is Int64 || featureValue is Int16){
    //                    setter = (Expression<Int64>(fieldName) <- Int64(featureValue as! Int))
    //                }
    //                else{
    //                    setter = (Expression<Int64>(fieldName) <- Int64(featureValue as! String)!)
    //                }
    //            case .Int64:
    //                setter = (Expression<Int64>(fieldName) <- Int64(featureValue as! String)!)
    //
    //            case .UInt16:
    //                setter = (Expression<Int64>(fieldName) <- Int64(featureValue as! UInt16))
    //
    //            case .UInt32:
    //                setter = (Expression<Int64>(fieldName) <- Int64(featureValue as! UInt32))
    //
    //            case .UInt64:
    //                setter = (Expression<Int64>(fieldName) <- Int64(featureValue as! UInt64))
    //
    //            case .Float:
    //                setter = (Expression<Int64>(fieldName) <- Int64(featureValue as! Float))
    //
    //            case .Double:
    //                if( featureValue is NSNull)
    //                {
    //                    continue
    //                }
    //                setter = (Expression<Double>(fieldName) <- featureValue as! Double)
    //
    //            case .Decimal:
    //                setter = nil
    //
    //            case .String:
    //                setter = (Expression<String>(fieldName) <- featureValue as! String)
    //
    //            case .DateTime:
    //                if(featureValue is String){
    //                    if(featureValue as! String == ""){
    //                     continue
    //                    }
    //
    //                    setter = (Expression<String>(fieldName) <- (featureValue as! String).replacingOccurrences(of: "\\", with: ""))
    //                }else if featureValue is Date{
    //                    if(featureValue == nil){
    //                        continue
    //                    }
    //                    setter = (Expression<Date>(fieldName) <- (featureValue as! Date))
    //                }
    //            case .Guid:
    //                let val = (featureValue as! String)
    //                if(val != "")
    //                {
    //                    setter = (Expression<String>(fieldName) <- featureValue as! String)
    //                }
    //                else {
    //                    continue
    //                }
    //
    //
    //            case .Geometry:
    //                setter = nil
    //
    //            case .Object:
    //                setter = nil
    //            default:
    //                setter = nil
    //
    //            }
    //            if(setter == nil)
    //            {
    //                continue
    //            }
    //            setters.append(setter!)
    //
    //        }
    //        let insertScrpt = Table(_layer.getName()).insert(setters)
    //        _dataSource.executeNonQuery(insertSql:insertScrpt)
    //    }
    func delete(_ featureId: Int) {
        
    }
    
    func update(_ feature: IMcxFeature) {
        var expressibles:[Expressible] = [Expressible]()
        var setters:[Setter]  = [Setter]()
        for i in 0..<feature.getFieldCount(){
            let fieldName:String = feature.getFieldName(ordinal: i)
            let featureValue = feature.getValueWithName(name: fieldName)
            let fieldType:McxDataTypeCode = feature.getField(ordinalName: i as AnyObject).getFieldType()
            if feature.getFieldName(ordinal: i) == "FEATUREID"{
                if feature.getValueWithName(name: feature.getFieldName(ordinal: i)) == nil{
                    continue
                }
            }
            var setter:Setter? = nil
            if featureValue == nil || featureValue is NSNull
            {
                continue
            }
            
            switch fieldType{
                
            case .Boolean:
                setter = (Expression<Bool>(fieldName) <- featureValue as! Bool)
            case .Byte:
                setter = (Expression<Int64>(fieldName) <- Int64(featureValue as! String)!)
            case .Int16:
                setter = (Expression<Int64>(fieldName) <- Int64(featureValue as! Int16))
                
            case .Int32:
                if((featureValue is Int)){
                    if((featureValue as! Int) != nil){
                        setter = (Expression<Int64>(fieldName) <- Int64(featureValue as! Int))
                    }else{
                        continue
                    }
                }
                else if (featureValue is String){
                    if((featureValue as! NSString) != ""){
                        setter = (Expression<Int64>(fieldName) <- Int64(featureValue as! Int))
                    }else{
                        continue
                    }
                  
                }
            case .Int64:
                setter = (Expression<Int64>(fieldName) <- Int64(featureValue as! String)!)
                
            case .UInt16:
                setter = (Expression<Int64>(fieldName) <- Int64(featureValue as! UInt16))
                
            case .UInt32:
                setter = (Expression<Int64>(fieldName) <- Int64(featureValue as! UInt32))
                
            case .UInt64:
                setter = (Expression<Int64>(fieldName) <- Int64(featureValue as! UInt64))
                
            case .Float:
                setter = (Expression<Int64>(fieldName) <- Int64(featureValue as! Float))
                
            case .Double:
                if  (featureValue as! NSString) != ""{
                    setter = (Expression<Double>(fieldName) <- featureValue as! Double)
                }
                else{
                    continue
                }
                
            case .Decimal:
                setter = nil
                
            case .String:
                setter = (Expression<String>(fieldName) <- featureValue as! String)
                
            case .DateTime:
                if(featureValue is String){
                    
                        if (featureValue as! String == ""){
                            let dateFormatterPrint = DateFormatter()
                            dateFormatterPrint.dateFormat = "dd-MM-yyyy HH:mm"
                            let date:String =  dateFormatterPrint.string(from: Date())
                              setter = (Expression<String>(fieldName) <- (date))
                        }
    
                        else{
                            setter = (Expression<String>(fieldName) <- (featureValue).replacingOccurrences(of: "\\", with: ""))
                        }
                    }

                
            case .Guid:
                let val = (featureValue as! String)
                if(val != "")
                {
                    setter = (Expression<String>(fieldName) <- featureValue as! String)
                }
                else {
                    continue
                }
                
                
            case .Geometry:
                setter = nil
                
            case .Object:
                setter = nil
            default:
                setter = nil
                
            }
            if(setter == nil)
            {
                continue
            }
            setters.append(setter!)
            
        }
        let layer = Table(_layer.getName())
        let updateLayer = layer.filter(Expression<Int>(_layer.getKeyField()) == feature.getFeatureId())
        let updateScrpt = updateLayer.update(setters)
        _dataSource.executeNonQuery(updateSql:updateScrpt)
    }
    
    
}
extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
}
