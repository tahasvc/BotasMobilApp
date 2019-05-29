//
//  IMcxSchema.swift
//  BotasMobilApp
//
//  Created by Admin on 17.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
protocol IMcxSchema {
    func getFieldCount() -> Int
    
    func getField(ordinal:Int) -> IMcxFieldDefinition
    
    func getField(name:String) -> IMcxFieldDefinition
    
    func getFields() -> [IMcxFieldDefinition]
    
    func getAttributes() -> [IMcxFieldDefinition]
    
    func addFieldRange(fields:[IMcxFieldDefinition])
}
