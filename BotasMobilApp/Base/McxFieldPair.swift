//
//  McxFieldPair.swift
//  BotasMobilApp
//
//  Created by Admin on 2.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxFieldPair {
    private var _fieldDefinition:IMcxFieldDefinition
    private var _value:AnyObject
    init(fieldDefinition:IMcxFieldDefinition,value:AnyObject) {
        self._fieldDefinition = fieldDefinition
        self._value = value
    }
    public func getFieldDefinition() -> IMcxFieldDefinition{
        return self._fieldDefinition
    }
    public func getValue()-> AnyObject{
        return self._value
    }
    public func setValue(value:AnyObject) -> () {
        self._value=value
    }
}
