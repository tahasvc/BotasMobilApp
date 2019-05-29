//
//  BotasMobilDataBaseHelper.swift
//  BotasMobilApp
//
//  Created by Admin on 15.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import SQLite3
class BotasMobilDataBaseHelper{
    var targetDataSource:McxSqliteDataSource!
    static var _gorevTypeLayer:IMcxLayer!
    static var _gorevLayer:IMcxLayer!
        static var _surecLayer:IMcxLayer!
    func createDataSource(dbSource:String,dbName:String) -> () {
        do{
            var driver:IMcxDriver = McxSqliteDriver()
            let bundlePath = Bundle.main.path(forResource: "botas_seed", ofType: ".sqlite")
            
            let fullDestPath = NSURL(fileURLWithPath: dbSource).appendingPathComponent(dbName + ".sqlite")
            let dbs = fullDestPath?.path
            
            try FileManager.default.copyItem(atPath: bundlePath!, toPath:dbs! )
            targetDataSource = driver.openDataSource(source: dbs!) as! McxSqliteDataSource
        }catch{
            print(error)
        }
        
        
    }
    static func getLocalGorevLayer() -> IMcxLayer? {
        if(_gorevLayer != nil){
            return _gorevLayer
        }
        let layer:IMcxLayer = BotasMobilApplication.localDataManager().getLayer(layerName: BotasMobilSettings.bakimOnarimLayer)
        if(layer != nil)
        {
            _gorevLayer = layer
        }
        
        return _gorevLayer
    }
    static func getLocalGorevTypeLayer() -> IMcxLayer{
        if(_gorevTypeLayer != nil){
            return _gorevTypeLayer
        }
        let layer:IMcxLayer = BotasMobilApplication.localDataManager().getLayer(layerName: BotasMobilSettings.gorevTypeLayer)
        if(layer != nil)
        {
            _gorevTypeLayer = layer
        }
        
        return _gorevTypeLayer
    }
    static func getLocalSurecLayer() -> IMcxLayer{
        if(_surecLayer != nil){
            return _surecLayer
        }
        let layer:IMcxLayer = BotasMobilApplication.localDataManager().getLayer(layerName: BotasMobilSettings.surecLayer)
        if(layer != nil)
        {
            _surecLayer = layer
        }
        
        return _surecLayer
    }
    func getDataSource() -> McxSqliteDataSource {
        return self.targetDataSource
    }
    class func insertFeature(_ feature:IMcxFeature ,_ layer:IMcxLayer){
        let edit:IMcxEdit = layer.createEdit()
        edit.insert(feature)
    }
    class func updateFeature(_ feature:IMcxFeature,_ layer:IMcxLayer) -> () {
        let edit:IMcxEdit=layer.createEdit()
        edit.update(feature)
    }
    class func setChangesForInsertOrUpdate(_ layer:IMcxLayer,_ id:Int,_ histroyType:McxSqliteHistoryType) -> () {
        let dataSource:McxSqliteDataSource = BotasMobilApplication.localDataManager().getDataSource() as! McxSqliteDataSource
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        
        let dateStr = formatter.string(from: Date())
        let tableId:Int = layer.getTableId()
        var cmdText:String = String(format: "SELECT COUNT(*) FROM MCX_CHANGES WHERE TABLEID= %d AND FEATUREID= %d", tableId,id)
        let isThere:Int = dataSource.executeScalarQuery(cmdText)
        if isThere == 0 {
            cmdText = "INSERT INTO MCX_CHANGES VALUES(%d,%d,NULL,0,NULL,'%@','%d')"
            cmdText = String(format: cmdText, tableId,id,dateStr,0)
        }
        if histroyType == McxSqliteHistoryType.Inserted{
            cmdText = "INSERT INTO MCX_CHANGES VALUES(%d,%d,NULL,0,NULL,'%@','%d')"
            cmdText = String(format: cmdText, tableId,id,dateStr,histroyType.rawValue)
        }else if histroyType == McxSqliteHistoryType.Updated{
            cmdText = "UPDATE MCX_CHANGES SET HISTORY_TYPE =" + String(McxSqliteHistoryType.Updated.rawValue) + "WHERE TABLEID=%d AND FEATUREID=%d"
            cmdText = String(format: cmdText, tableId,id)
        }
        dataSource.executeNonQuery(cmdText)
    }
    class func getHistoryTypeWithMcxChanges(_ tableId:Int ,_ featureId:Int) -> String {
        let dataSource:McxSqliteDataSource = BotasMobilApplication.localDataManager().getDataSource() as! McxSqliteDataSource
        let cmdText:String = String(format: "SELECT HISTORY_TYPE FROM MCX_CHANGES WHERE TABLEID=%d AND FEATUREID=%d", tableId,featureId)
        let historyType:String = String(dataSource.executeScalarQuery(cmdText))
        
        return historyType
    }
}

extension IMcxLayer{
    func getTableId() -> Int {
        var tableId:Int = -1
        let layer:IMcxLayer = BotasMobilApplication.localDataManager().getLayer(layerName: "MCX_LAYERINFO")
        let reader = layer.search("TABLENAME='" + self.getName() + "'").getFeatureReader()
        if reader.read(){
            tableId = reader.getCurrent().getValueWithName(name: "TABLEID") as! Int
        }
        return tableId
    }
}
