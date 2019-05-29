//
//  McxCoordinateSystem.swift
//  BotasMobilApp
//
//  Created by Admin on 8.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxCoordinateSystem: IMcxCoordinateSystem {
    private var _authorityCode:String?
    func getAuthorityCode() -> String {
        return self._authorityCode!
    }
    func setAuthorityCode(_ code:String) -> () {
        self._authorityCode = code
    }
    
    
}
