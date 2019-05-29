//
//  BotasMobilCheckOutAction.swift
//  BotasMobilApp
//
//  Created by Admin on 16.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import MapKit
class BotasMobilCheckOutAction :McxAction {
    var _taskId:Int!
    var _guid:String!
    var _data:String!
    var _dbHelper:BotasMobilDataBaseHelper!
    var _localDataMngr:BotasMobilLocalDataManager!
    var _taskGlobalId:String!
    var _boruHatGlobalId:String!
    init(taskId:Int) {
        _taskId = taskId
    }
    override func onExecute() -> () {
        _guid =  UUID().uuidString
        let dirPath:String = BotasMobilHelper.getDataDirPath()
        _data = dirPath + "/" + _guid + "/"
        
        do {
            try FileManager.default.createDirectory(atPath: _data, withIntermediateDirectories: false, attributes: nil)
            
            try FileManager.default.createDirectory(atPath: _data + "Photo", withIntermediateDirectories: false, attributes: nil)
            _dbHelper = BotasMobilDataBaseHelper()
            BotasMobilHelper.showSpinner()
            self.startCheckOut()
            
            BotasMobilHelper.removeSpinner()
        }catch{
            print(error)
            BotasMobilHelper.removeSpinner()
        }
        
        
    }
    func startCheckOut() {
        _dbHelper.createDataSource(dbSource:_data,dbName:_guid)
        _localDataMngr = BotasMobilApplication.localDataManager(source: self._dbHelper.getDataSource().getName())
        self.extractBakimOnarimLayer()
        self.extractBoSurecLayer()
        self.extractMcxUserLayer()
        self.extractGorevTypeLayer()
        self.extreactPlanliAlanLayer()
        self.extractPlansizAlanLayer()
    }
    func extractBakimOnarimLayer() {
        let localLayer:IMcxLayer = _localDataMngr.getLayer(layerName: BotasMobilSettings.bakimOnarimLayer)
        let targetLayer:IMcxLayer = BotasMobilApplication.dataManager().getLayer(BotasMobilSettings.bakimOnarimLayer)
        let whereClause = String(format: "FEATUREID=%d", _taskId)
        let reader:IMcxFeatureReader = (targetLayer.query(fields: "", whereClause: whereClause, layer: targetLayer)?.getFeatureReader())!
        
        if reader.read(){
            let feature:IMcxFeature = reader.getCurrent()
            let localFeature:IMcxFeature = localLayer.createFeatureBuffer()!
            localFeature.setFeatureId(featureId: feature.getFeatureId())
            localFeature.setValue(ordinalOrName: "GLOBALID" as AnyObject, value: feature.getValueWithName(name: "GLOBALID"))
            _taskGlobalId = (localFeature.getValueWithName(name: "GLOBALID") as! String).replacingOccurrences(of: "-", with: "").uppercased()
            localFeature.setGeometry(geometry: feature.getGeometry()!)
            localFeature.setValue(ordinalOrName: "BORUHAT_GLOBALID" as AnyObject, value: feature.getValueWithName(name: "BORUHAT_GLOBALID"))
            _boruHatGlobalId = (localFeature.getValueWithName(name: "BORUHAT_GLOBALID") as! String).replacingOccurrences(of: "-", with: "").uppercased()
            localFeature.setValue(ordinalOrName: "BORUHAT_GLOBALID" as AnyObject, value: _boruHatGlobalId as AnyObject)
            localFeature.setValue(ordinalOrName: "TESISLER_GLOBALID" as AnyObject, value: feature.getValueWithName(name: "TESISLER_GLOBALID"))
            localFeature.setValue(ordinalOrName: "DOMAINID" as AnyObject, value: feature.getValueWithName(name: "DOMAINID"))
            localFeature.setValue(ordinalOrName: "ADI_NUMARASI" as AnyObject, value: feature.getValueWithName(name: "ADI_NUMARASI"))
            localFeature.setValue(ordinalOrName: "TAMIR_TIPI" as AnyObject, value: feature.getValueWithName(name: "TAMIR_TIPI"))
            localFeature.setValue(ordinalOrName: "CREATE_DATE" as AnyObject,value: feature.getValueWithName(name: "CREATE_DATE"))
            localFeature.setValue(ordinalOrName: "CREATE_USER" as AnyObject, value: feature.getValueWithName(name: "CREATE_USER"))
            localFeature.setValue(ordinalOrName: "DURUMID" as AnyObject, value: feature.getValueWithName(name: "DURUMID"))
            localFeature.setValue(ordinalOrName: "ACIKLAMA" as AnyObject, value: feature.getValueWithName(name: "ACIKLAMA"))
            localFeature.setValue(ordinalOrName: "CHECKOUT_DATE" as AnyObject,value: feature.getValueWithName(name:"CHECKOUT_DATE"))
            localFeature.setValue(ordinalOrName:"DOSYA" as AnyObject, value: feature.getValueWithName(name:"DOSYA"))
            localFeature.setValue(ordinalOrName: "CHECKIN_DATE" as AnyObject ,value: feature.getValueWithName(name:"CHECKIN_DATE"))
            let edit:IMcxEdit = localLayer.createEdit()
            edit.insert(localFeature)
            
        }
    }
    private func extractBoSurecLayer() {
        
        let  localLayer:IMcxLayer = _localDataMngr.getLayer(layerName: BotasMobilSettings.surecLayer);
        let targetLayer:IMcxLayer = BotasMobilApplication.dataManager().getLayer(BotasMobilSettings.surecLayer);
        //        let glob = (_taskGlobalId.uuidString).uppercased()
        let whereClause:String = String(format: "BAKIMONARIM_REF=%@", "'" + _taskGlobalId + "'")
        let reader:IMcxFeatureReader = (targetLayer.search(fields: "", whereClause: whereClause, geometry: nil, relation: "", ajaxParameter: "")?.getFeatureReader())!
        while reader.read() {
            let feature:IMcxFeature = reader.getCurrent();
            let localFeature:IMcxFeature = localLayer.createFeatureBuffer()!;
            localFeature.setFeatureId(featureId: feature.getFeatureId())
            let geom = feature.getGeometry() as! MKCircle
            localFeature.setGeometry(geometry: feature.getGeometry()!)
            localFeature.setValue(ordinalOrName: "GLOBALID" as AnyObject, value: feature.getValueWithName(name: "GLOBALID"))
            localFeature.setValue(ordinalOrName: "BAKIMONARIM_REF" as AnyObject, value: feature.getValueWithName(name: "BAKIMONARIM_REF"));
            localFeature.setValue(ordinalOrName: "ONAY_DURUM" as AnyObject, value: feature.getValueWithName(name: "ONAY_DURUM"));
            localFeature.setValue(ordinalOrName: "TAMIR_TIP_REF" as AnyObject, value: feature.getValueWithName(name: "TAMIR_TIP_REF"));
            localFeature.setValue(ordinalOrName: "PLAN_TYPE" as AnyObject, value: feature.getValueWithName(name: "PLAN_TYPE"));
            localFeature.setValue(ordinalOrName: "EKIP_REF" as AnyObject, value: feature.getValueWithName(name: "EKIP_REF"));
            localFeature.setValue(ordinalOrName: "GIDERILDI" as AnyObject, value: feature.getValueWithName(name: "GIDERILDI"));
            localFeature.setValue(ordinalOrName: "TESPIT_EDILDI" as AnyObject, value: feature.getValueWithName(name: "TESPIT_EDILDI"));
            localFeature.setValue(ordinalOrName: "ACIKLAMA" as AnyObject, value: feature.getValueWithName(name: "ACIKLAMA"));
            localFeature.setValue(ordinalOrName: "GOREV_TYPE" as AnyObject, value: feature.getValueWithName(name: "GOREV_TYPE"));
            localFeature.setValue(ordinalOrName: "CREATE_DATE" as AnyObject,value: feature.getValueWithName(name: "CREATE_DATE"))
            localFeature.setValue(ordinalOrName: "UPDATE_DATE" as AnyObject, value:feature.getValueWithName(name: "UPDATE_DATE"))
            let edit:IMcxEdit = localLayer.createEdit()
            edit.insert(localFeature)
        }
    }
    private func extractMcxUserLayer() {
        let localLayer:IMcxLayer = _localDataMngr.getLayer(layerName: BotasMobilSettings.mcxUsersTableName);
        let targetLayer:IMcxLayer = BotasMobilApplication.dataManager().getLayer(BotasMobilSettings.mcxUsersTableName);
        var reader:IMcxFeatureReader? = nil
        let whereClause:String = "ID='" + String(BotasMobilApplication.userManager.getUserId()) + "'"
        reader = targetLayer.query(fields: "", whereClause: whereClause, layer: targetLayer)?.getFeatureReader()
        while reader!.read(){
            let feature:IMcxFeature = reader!.getCurrent();
            let localFeature:IMcxFeature = localLayer.createFeatureBuffer()!;
            localFeature.setValue(ordinalOrName: "ID" as AnyObject, value: feature.getValueWithName(name: "ID"));
            localFeature.setValue(ordinalOrName: "USERNAME" as AnyObject, value: feature.getValueWithName(name: "USERNAME"));
            localFeature.setValue(ordinalOrName: "PASSW" as AnyObject, value: feature.getValueWithName(name: "PASSW"));
            localFeature.setValue(ordinalOrName: "DISPLAYNAME" as AnyObject, value: feature.getValueWithName(name: "DISPLAYNAME"));
            localFeature.setValue(ordinalOrName: "ISGROUP" as AnyObject, value: feature.getValueWithName(name: "ISGROUP"));
            localFeature.setValue(ordinalOrName: "ISLOCKED" as AnyObject, value: feature.getValueWithName(name: "ISLOCKED"));
            localFeature.setValue(ordinalOrName: "IPADDRESS" as AnyObject, value: feature.getValueWithName(name: "IPADDRESS"));
            localFeature.setValue(ordinalOrName: "EMAIL" as AnyObject, value: feature.getValueWithName(name: "EMAIL"));
            localFeature.setValue(ordinalOrName: "URI" as AnyObject, value: feature.getValueWithName(name: "URI"));
            localFeature.setValue(ordinalOrName: "NODEID" as AnyObject, value: feature.getValueWithName(name: "NODEID"));
            
            let edit:IMcxEdit = localLayer.createEdit();
            edit.insert(localFeature);
        }
    }
    
    func extractGorevTypeLayer() -> () {
        let localLayer:IMcxLayer = _localDataMngr.getLayer(layerName: BotasMobilSettings.gorevTypeLayer)
        let targetLayer:IMcxLayer = BotasMobilApplication.dataManager().getLayer(BotasMobilSettings.gorevTypeLayer)
        let whereClause:String = "BAKIM_ONARIM_GLOBALID='" + _taskGlobalId + "'"
        let reader:IMcxFeatureReader = (targetLayer.search(fields: "", whereClause: whereClause, geometry: nil, relation: "", ajaxParameter: "")?.getFeatureReader())!
        while reader.read() {
            let feature:IMcxFeature = reader.getCurrent()
            let localFeature:IMcxFeature = localLayer.createFeatureBuffer()!
            localFeature.setFeatureId(featureId: feature.getFeatureId())
            localFeature.setValue(ordinalOrName: "GLOBALID" as AnyObject, value: feature.getValueWithName(name: "GLOBALID"))
            localFeature.setValue(ordinalOrName: "BAKIM_ONARIM_GLOBALID" as AnyObject, value: feature.getValueWithName(name: "BAKIM_ONARIM_GLOBALID"))
            localFeature.setValue(ordinalOrName: "GOREV_TIP" as AnyObject, value: feature.getValueWithName(name: "GOREV_TIP"))
            let edit:IMcxEdit = localLayer.createEdit()
            edit.insert(localFeature)
        }        
    }
    func extreactPlanliAlanLayer() -> () {
        let localLayer:IMcxLayer = _localDataMngr.getLayer(layerName: BotasMobilSettings.planliAlanLayer)
        let targetLayer:IMcxLayer = BotasMobilApplication.dataManager().getLayer("VT_BORU_HATTI")
        if _boruHatGlobalId != nil{
            let attributeFilter:String = "GLOBALID='" + _boruHatGlobalId.uppercased().replacingOccurrences(of: "-", with: "") + "'"
            let reader:IMcxFeatureReader = targetLayer.search(attributeFilter).getFeatureReader()
            while reader.read(){
                let feature:IMcxFeature = reader.getCurrent()
                let refFeatureId:Int = feature.getFeatureId()
                let planFeature:IMcxFeature = localLayer.createFeatureBuffer()!
                planFeature.setFeatureId(featureId: refFeatureId)
                planFeature.setValue(ordinalOrName: "GLOBALID" as AnyObject, value: UUID().uuidString as AnyObject)
                planFeature.setGeometry(geometry: feature.getGeometry()!)
                BotasMobilDataBaseHelper.insertFeature(planFeature, localLayer)
            }
        }
    }
    func extractPlansizAlanLayer() -> () {
        
    }
}
extension String {
    var unescaped: String {
        let entities = ["\0", "\t", "\n", "\r", "\"", "\'", "\\"]
        var current = self
        for entity in entities {
            let descriptionCharacters = entity.debugDescription.characters.dropFirst().dropLast()
            let description = String(descriptionCharacters)
            current = current.replacingOccurrences(of: description, with: entity)
        }
        return current
    }
}
