//
//  IMcxDriver.swift
//  BotasMobilApp
//
//  Created by Admin on 19.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

protocol IMcxDriver {
    func getName() -> String
    
    func openDataSource(source:String) -> IMcxDataSource?
}
