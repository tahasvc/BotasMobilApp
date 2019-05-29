//
//  McxServerTransaction.swift
//  BotasMobilApp
//
//  Created by Admin on 22.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxServerTransaction {
    private var _layer:McxFsLayer
    private var _insertFeatures:[IMcxFeature]
    private var _updateFeatures:[IMcxFeature]
    private var _deleteFeatures:[IMcxFeature]
    private var _credentials:String
    
    init(_ layer:McxFsLayer,_ credentials:String) {
        self._layer = layer
        self._insertFeatures = [IMcxFeature]()
        self._updateFeatures = [IMcxFeature]()
        self._deleteFeatures = [IMcxFeature]()
        self._credentials = credentials
    }
    func addInsertList(_ feature:IMcxFeature) -> Bool {
        self._insertFeatures.append(feature)
        
        return true
    }
    func addDeleteList(_ featureId:Int) -> () {
        let featureBuffer:IMcxFeature = self._layer.createFeatureBuffer()!
        featureBuffer.setFeatureId(featureId: featureId)
        self._deleteFeatures.append(featureBuffer)
    }
    func addUpdateList(_ feature:IMcxFeature) -> () {
        self._updateFeatures.append(feature)
    }
//    let parameters: [String: Any] = [
//        "AttributeFilter": whereClause,
//        "Envelope": "", // #todo yazılıacak
//        "Fields": fields,
//        "Filters": "", // #todo yazılıacak
//        "Geometry": geometry ?? "",
//        "LayerName": self._layerServerName,
//        "Token": self._credentials,
//        "Relation": relation,
//        "Min":-1,
//        "Max":-1
//    ]
    func commit() -> String {
        if self._updateFeatures.count > 0 {
            var featureString:String = McxServerConverter.featureToString(self._updateFeatures, "", false)
            var queryString:String = self._layer.getFullName() + "updateFeatures"

                let parameters: [String: Any] = [
                    "Token": self._credentials,
                    "LayerName": self._layer.getServerLayerName(),
                    "Features": featureString,
                    "Url" : queryString
                ]
            var resp:String = JsonParser().postExecute(url: queryString, parameters: parameters)
            
        }
        
        if self._insertFeatures.count > 0 {
            let featureToString =  McxServerConverter.featureToString(self._insertFeatures, "", false)
            let queryString = self._layer.getFullName() + "insertFeatures"
            let parameters: [String: Any] = [
                "Token": self._credentials,
                "LayerName": self._layer.getServerLayerName(),
                "Features": featureToString,
                "Url" : queryString
            ]
             var resp:String = JsonParser().postExecute(url: queryString, parameters: parameters)
        }
        
        return ""
    }
}
