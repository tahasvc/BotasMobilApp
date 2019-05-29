//
//  McxFieldDefinition.swift
//  BotasMobilApp
//
//  Created by Admin on 30.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxFieldDefinition: IMcxFieldDefinition {
    private var alias:String = ""
    private var fieldName:String = ""
    private var domainName:String = ""
    private var editable:Bool = false
    private var ignored:Bool = false
    private var primaryKey:Bool = false
    private var required:Bool = false
    private var presicion:Int = 0
    private var size:Int = 0
    private var defaultValue:AnyObject? = nil
    private var fieldType:McxDataTypeCode = McxDataTypeCode.Object
    
    func getFieldName() -> String {
        return self.fieldName
    }
    
    func setFieldName(fieldName: String) {
        self.fieldName=fieldName
    }
    
    func getSize() -> Int {
        return self.size
    }
    
    func setSize(size: Int) {
        self.size=size
    }
    
    func setIsPrimaryKey(isPrimaryKey: Bool) {
        self.primaryKey = isPrimaryKey
    }
    func getFieldType() -> McxDataTypeCode {
        return self.fieldType
    }
    func setFieldType(fieldType: String) {
        switch fieldType {
        case "IMcxGeometry":
            self.fieldType = McxDataTypeCode.IMcxGeometry
            break;
        case "IMcxSymbolizer":
            self.fieldType = McxDataTypeCode.IMcxSymbolizer
            break;
        case "Boolean":
            self.fieldType = McxDataTypeCode.Boolean
            break;
        case "Byte":
            self.fieldType = McxDataTypeCode.Byte
            break;
        case "Int16":
            self.fieldType = McxDataTypeCode.Int16
            break;
        case "Int32":
            self.fieldType = McxDataTypeCode.Int32
            break;
        case "Int64":
            self.fieldType = McxDataTypeCode.Int64
            break;
        case "Float":
            self.fieldType = McxDataTypeCode.Float
            break;
        case "Double":
            self.fieldType = McxDataTypeCode.Double
            break;
        case "DateTime":
            self.fieldType = McxDataTypeCode.DateTime
            break;
        case "String":
            self.fieldType = McxDataTypeCode.String
            break;
        case "Guid":
            self.fieldType = McxDataTypeCode.Guid
            break;
        case "Object":
            self.fieldType = McxDataTypeCode.Object
            break;
        case "Unknown":
            self.fieldType = McxDataTypeCode.Unknown
            break;
            
        //SONRADAN EKLENEN
        case "INTEGER":
            self.fieldType = McxDataTypeCode.Int32
            break;
        case "INT":
            self.fieldType = McxDataTypeCode.Int32
            break;
        case "NOTE":
            self.fieldType = McxDataTypeCode.String
            break;
        case "VARCHAR":
            self.fieldType = McxDataTypeCode.String
            break;
        case "DATETIME":
            self.fieldType = McxDataTypeCode.DateTime
            break;
        case "DOUBLE":
            self.fieldType = McxDataTypeCode.Double
            break;
        case "UUID":
            self.fieldType = McxDataTypeCode.Guid
            break;
        case "TEXT":
            self.fieldType = McxDataTypeCode.String
            break;
            
        default:
            self.fieldType = McxDataTypeCode.IMcxGeometry
        }
    }
    func setDefaultValue(defaultValue: AnyObject) {
        self.defaultValue = defaultValue
    }
}
