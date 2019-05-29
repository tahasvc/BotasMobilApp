//
//  McxSqliteDriver.swift
//  BotasMobilApp
//
//  Created by Admin on 16.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxSqliteDriver: IMcxDriver {
    func openDataSource(source: String) -> IMcxDataSource? {
        let dataSource:IMcxDataSource = McxSqliteDataSource(source: source, driver: self)
        
        return dataSource
    }
    
    
    func getName() -> String {
        return ""
    }
    
    
}
