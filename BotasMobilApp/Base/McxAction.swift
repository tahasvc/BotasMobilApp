//
//  McxAction.swift
//  BotasMobilApp
//
//  Created by Admin on 16.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxAction: IMcxAction {
    func execute() -> () {
        return self.onExecute()
    }
    
    internal func onExecute() -> (){
    }
}
