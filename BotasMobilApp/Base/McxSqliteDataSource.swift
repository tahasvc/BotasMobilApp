//
//  McxSqliteDataSource.swift
//  BotasMobilApp
//
//  Created by Admin on 16.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import SQLite
class McxSqliteDataSource: McxAbstractDataSource{
    private var _sqlPath:String!
    private var db:Connection!
    init(source:String,driver:IMcxDriver) {
        super.init(driver: driver, source: source)
        do{
            self.db = try Connection(source)
            _sqlPath = source
        }catch{
            
        }
        
        
    }
    override func getLayer(layerName: String) -> McxGetLayerResult {
        return McxGetLayerResult()
    }
    override func getLayer(layerName: String) -> IMcxLayer? {
        var layer:IMcxLayer? = nil
        var fields:[IMcxFieldDefinition] = [IMcxFieldDefinition]()
        
        do{
            let str:String = String(format: "PRAGMA table_info(%@)",layerName)
            layer = McxSqliteLayer(name: layerName, dataSource: self)
            let stmt = try self.db.prepare(str)
            for item in stmt{
                let fieldName:String = item[1] as! String
                var fieldType:String = item[2] as! String
                if fieldType.starts(with: "VARCHAR"){
                    fieldType = "VARCHAR"
                }
                
                let defaultValue:AnyObject = item[4] as AnyObject
                let primaryKey:Bool = (item[5] as! Int64) == 1
                if(primaryKey){
                    layer?.setKeyField(keyField: fieldName)
                }
                
                let fieldDefinition:McxFieldDefinition = McxFieldDefinition()
                fieldDefinition.setIsPrimaryKey(isPrimaryKey: primaryKey)
                fieldDefinition.setFieldName(fieldName: fieldName)
                fieldDefinition.setDefaultValue(defaultValue: defaultValue)
                fieldDefinition.setFieldType(fieldType: fieldType)
                fields.append(fieldDefinition)
            }
            
        }catch{
            
        }
        
        layer?.getSchema().addFieldRange(fields: fields)
        
        return layer!
    }
    func executeNonQuery(insertSql:Insert) -> () {
        do{
            try self.db.run(insertSql)
        }catch{
            print(error)
        }
        
    }
    func executeNonQuery(updateSql:Update) -> () {
        do{
            try self.db.run(updateSql)
        }catch{
            print(error)
        }
        
    }
    func executeNonQuery(deleteSql:Delete) -> () {
        do{
            try self.db.run(deleteSql)
        }catch{
            print(error)
        }
        
    }
    func executeNonQuery(_ cmdText:String) -> () {
        do{
            try self.db.run(cmdText)
        }catch{
            print(error)
        }
    }
    func executeReader(_ tableName:String,_ whereCondition:String) -> Statement? {
        var reader:Statement? = nil
        do{
            var whereClause=String(format: "SELECT *FROM %@ WHERE %@",tableName,whereCondition)
            if(whereCondition == ""){
                whereClause = whereClause.replacingOccurrences(of: "WHERE", with: "")
            }
            reader = try db.prepare(whereClause)
        }catch{
            print(error)
        }
        
        return reader
    }
    func executeScalarQuery(_ cmdText:String) -> Int {
        var scalar:Int = -1
        do{
            scalar = try Int(truncating: db.scalar(cmdText) as! NSNumber)
        }catch{
            
        }
        return scalar
    }
}
