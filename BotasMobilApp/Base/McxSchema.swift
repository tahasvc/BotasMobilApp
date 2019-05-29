//
//  McxSchema.swift
//  BotasMobilApp
//
//  Created by Admin on 17.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxSchema: IMcxSchema {
    internal var _fields:[IMcxFieldDefinition] = [IMcxFieldDefinition]()
    
    func getFieldCount() -> Int {
        return _fields.count
    }
    
    func getField(ordinal: Int) -> IMcxFieldDefinition {
        return _fields[ordinal]
    }
    
    func getField(name: String) -> IMcxFieldDefinition {
        return McxFieldDefinition()
    }
    
    func getFields() -> [IMcxFieldDefinition] {
        return self._fields
        
    }
    
    func getAttributes() -> [IMcxFieldDefinition] {
        return self._fields
    }
    func addFieldRange(fields: [IMcxFieldDefinition]) {
        self._fields.append(contentsOf: fields)
    }
    
}
