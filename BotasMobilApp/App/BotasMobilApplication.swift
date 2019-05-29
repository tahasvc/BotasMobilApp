//
//  BotasMobilApplication.swift
//  BotasMobilApp
//
//  Created by Admin on 10.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class BotasMobilApplication {
    private static var  _localDataManager:BotasMobilLocalDataManager!
    private static var  _dataManager:BotasMobilDataManager!
    public static var userManager:BotasMobilUser!
    private static var _source = BotasMobilSettings.featureService
    private static var  _controller = McxController()
    
    class func localDataManager() -> BotasMobilLocalDataManager {
        if(_localDataManager != nil){
            return _localDataManager
        }
        _localDataManager = BotasMobilLocalDataManager()
        return _localDataManager
    }
    
    class func localDataManager(source:String) -> BotasMobilLocalDataManager {
        _localDataManager = BotasMobilLocalDataManager()
        _localDataManager.setDataSource(source)
        
         return _localDataManager
    }
    
    class func dataManager() -> BotasMobilDataManager {
        if _dataManager != nil{
            return _dataManager
        }
        _dataManager = BotasMobilDataManager(_source)
        
        return _dataManager
    }
    class func getController() -> McxController {
        return self._controller
    }
}
