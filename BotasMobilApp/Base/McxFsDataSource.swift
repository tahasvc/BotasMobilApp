//
//  McxFsDataSource.swift
//  BotasMobilApp
//
//  Created by Admin on 25.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxFsDataSource : McxAbstractDataSource{
    private var seriveUri:String = ""
    private var token:String = ""
    
    init(driver:IMcxDriver,source : String,token:String) {
        super.init(driver: driver, source: source)
        self.seriveUri = createServiceUri(source: source)
        self.token = token
    }
    override func getLayer(layerName: String) -> McxGetLayerResult {
        var getLayerResult:McxGetLayerResult=McxGetLayerResult()
        var layerNameArray = [String]()
        layerNameArray=layerName.components(separatedBy: ";")
        var newLayerNameArray = [String]()
        var foundLayerArray=[IMcxLayer]()
        for lName in layerNameArray {
            if(lName == ""){
                continue
            }
            var strings=[String]()
            strings = lName.components(separatedBy: ":")
            var serverLayerName:String=""
            if strings.count != 2 && strings[0] != "" {
                var uriStr:String = strings[0]
                do {
                    uriStr = Uri.decode(str: strings[0])
                    uriStr=Uri.decode(str: uriStr)
                    
                } catch {
                    uriStr=Uri.encode(str: strings[0])
                }
                serverLayerName = self._dataSourceName + ":" + uriStr
            }else{
                serverLayerName = lName
            }
            newLayerNameArray.append(serverLayerName)
        }
        
        var requestLayerArray=[String]()
        for newLName in newLayerNameArray {
            requestLayerArray.append(newLName)
        }
        
        var layerString:String = ""
        for requestLName in requestLayerArray {
            layerString += requestLName + ";"
        }
        
        var serviceUrl:String = self.seriveUri + "getLayer?"
        if self._credentials != nil && self._credentials != "" {
            serviceUrl += "token=" + Uri.encode(str: self.token) + "&"
//            serviceUrl += "token=" + self.token.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + "&"
        }
        
        serviceUrl += "layers=" + layerString
        let jsonParser=JsonParser()
        do{
//            serviceUrl = serviceUrl.replacingOccurrences(of: ";", with: "", options: .literal, range: nil)

            let response:String = jsonParser.getExecute(url: serviceUrl)
            let layer:IMcxLayer = McxFsLayer(dataSource: self,name: "",credentials: self.token,source: self.seriveUri,proxyLayer: response)
            foundLayerArray.append(layer)
            self.add(layer: layer)
            getLayerResult.setLayers(layers: foundLayerArray)
        }catch{
            
        }
        return getLayerResult
    }
    func createServiceUri(source :String) ->String{
        var split = [String]()
        split = source.components(separatedBy: "@")
        var searchUri:String = split[split.count-1]
        searchUri+="/Rest/Json/"
        
        return searchUri
    }
}
