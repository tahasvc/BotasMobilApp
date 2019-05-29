//
//  IMcxEdit.swift
//  BotasMobilApp
//
//  Created by Admin on 16.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
protocol IMcxEdit {
    
    func insert(_ feature:IMcxFeature) -> ()
    
    func delete(_ featureId:Int) -> ()
    
    func update(_ feature:IMcxFeature) -> ()
}
