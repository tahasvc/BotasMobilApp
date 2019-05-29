//
//  IMcxFieldDefinition.swift
//  BotasMobilApp
//
//  Created by Admin on 30.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
protocol IMcxFieldDefinition {
    func getFieldName() -> String
    
    func setFieldName(fieldName:String)
    
    func getSize() -> Int
    
    func setSize(size:Int)
    
    func setIsPrimaryKey(isPrimaryKey:Bool)
    
    func getFieldType() -> McxDataTypeCode
    
    func setFieldType(fieldType:String)
    
    func setDefaultValue(defaultValue:AnyObject) -> ()
}
