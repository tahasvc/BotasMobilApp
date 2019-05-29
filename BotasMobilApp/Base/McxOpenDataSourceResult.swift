//
//  McxOpenDataSourceResult.swift
//  BotasMobilApp
//
//  Created by Admin on 19.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxOpenDataSourceResult{
    private var dataSource:IMcxDataSource? = nil
    func getDataSource() -> IMcxDataSource {
        return self.dataSource!
    }
    func setDataSource(dataSource:IMcxDataSource) -> () {
        self.dataSource=dataSource
    }
}
