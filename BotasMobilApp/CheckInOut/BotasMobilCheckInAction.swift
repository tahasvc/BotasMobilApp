//
//  BotasMobilCheckInAction.swift
//  BotasMobilApp
//
//  Created by Admin on 22.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class BotasMobilCheckInAction: McxAction {
    private var _features:[IMcxFeature] = [IMcxFeature]()
    
    init(feature:IMcxFeature) {
        _features.append(feature)
    }
    init(features:[IMcxFeature]) {
        _features=features
    }
    override func onExecute() {
        self.startCheckIn()
    }
    func startCheckIn() -> () {
        let surecLayer:McxFsLayer = BotasMobilApplication.dataManager().getLayer(BotasMobilSettings.surecLayer) as! McxFsLayer
        let credentials:String = surecLayer.getCredentials()
        let tableId:Int = BotasMobilDataBaseHelper.getLocalSurecLayer().getTableId()
        for feature in self._features{
            let serverTransaction:McxServerTransaction = McxServerTransaction(surecLayer as! McxFsLayer, credentials)
            let serverFeature:IMcxFeature = surecLayer.createFeatureBuffer()!
            for i in 0..<feature.getFieldCount(){
                let fieldName:String = feature.getFieldName(ordinal: i)
                serverFeature.setValue(ordinalOrName: fieldName as AnyObject, value: feature.getValueWithName(name: fieldName))
                
            }
            let historyType:String = BotasMobilDataBaseHelper.getHistoryTypeWithMcxChanges(tableId,feature.getFeatureId())
            if historyType == String(McxSqliteHistoryType.Updated.rawValue){
                serverTransaction.addUpdateList(serverFeature)
            }
            else{
                serverTransaction.addInsertList(serverFeature)
            }
            
            let response:String = serverTransaction.commit()
            if(!(response == "failed")){
                let dataSource:McxSqliteDataSource = BotasMobilApplication.localDataManager().getDataSource() as! McxSqliteDataSource
                let cmdText:String = String(format: "UPDATE MCX_CHANGES SET HISTORY_TYPE = -1 WHERE TABLEID=%d AND FEATUREID=%d", tableId,feature.getFeatureId())
                dataSource.executeNonQuery(cmdText)
                
            }
        }
    }
}
