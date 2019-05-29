//
//  BotasMobilUser.swift
//  BotasMobilApp
//
//  Created by Admin on 14.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class BotasMobilUser {
    private var _userId:Int!
    private var _userName:String!
    private var _displayName:String!
    
    func getUserName() -> String {
        return self._userName
    }
    func setUserName(_ name:String) -> () {
        _userName = name
    }
    func getUserId() -> Int {
        return self._userId
    }
    func setUserId(_ id:Int) -> () {
        _userId=id
    }
}
