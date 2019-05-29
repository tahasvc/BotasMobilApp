//
//  McxFsLayer.swift
//  BotasMobilApp
//
//  Created by Admin on 26.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxFsLayer : McxAbstractLayer{
    private var _dataSource:IMcxDataSource
    private var _layerServerName:String
    private var _credentials:String
    private var _layerDescription:String
    private var _geometryType:McxGeometryType
    init(dataSource:IMcxDataSource,name:String,credentials:String,source:String,proxyLayer:String) {
        self._dataSource=dataSource
        self._layerServerName=""
        self._credentials=credentials
        self._layerDescription=""
        self._geometryType=McxGeometryType.Unknown
        super.init(dataSource: dataSource, name: name)
        self.fullName=source
        self.initialize(metaData: proxyLayer)
    }
    func initialize(metaData:String) -> () {
        let metaDataJson:Dictionary<String,Any> = metaData.getJsonArray()
        do{
            let authorityCode = String(metaDataJson["AuthorityCode"] as! Int)
            var cord=McxCoordinateSystem()
            cord.setAuthorityCode(authorityCode)
            self._coordinateSystem = cord
            let layerDesc = metaDataJson["Description"] as? String
            if(layerDesc != nil){
                self._layerDescription = layerDesc!
            }
            let geometryField:String = metaDataJson["GeometryField"] as! String
            if(geometryField != nil && geometryField != ""){
                self._geometryField = geometryField
            }
            let keyField:String = metaDataJson["KeyField"] as! String
            if(keyField != nil && keyField != ""){
                self.setKeyField(keyField: keyField)
            }
            let geoType:Int = (metaDataJson["GeometryType"] as? Int)!
            if(geoType != nil){
                self._geometryType = McxGeometryType.init(rawValue: geoType)!
                self._layerServerName = (metaDataJson["Name"] as? String)!
                self.fieldDefinitionArray = self.fillFieldDefinions(fieldDefJson: (metaDataJson["FieldDefinitions"] as?
                    [Dictionary<String,Any>])!)
            }
        }catch{
            
        }
    }
    override func query(fields:String,whereClause:String,layer:IMcxLayer) -> McxSearchResult {
        var fieldsOrdered:String=""
        if(fields != ""){
            let fieldsArray = fields.index(fields.startIndex, offsetBy: 1)..<fields.index(fields.endIndex, offsetBy:-1)
            fieldsOrdered = String(fields[fieldsArray])
            fieldsOrdered = fieldsOrdered.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }
        
        let layerString:String="layerName="+self._layerServerName
        let credentialString:String="token="+Uri.encode(str: self._credentials)
        let filterString:String="filters="
        let attributeFilter:String="attributeFilter=" + whereClause
        var fieldsString="fields="+fields
        if(fieldsOrdered != nil && fieldsOrdered != ""){
            fieldsString+=fieldsOrdered
        }else{
            fieldsOrdered=""
        }
        
        let minValue:String="min=" + "-1"
        let maxValue:String="max=" + "-1"
        
        var queryStringForPixel:String = self.fullName + "Query?" + credentialString + "&" + layerString + "&" + filterString + "&" + fieldsString + "&" + Uri.encode(str:attributeFilter) + "&" + minValue + "&" + maxValue
        
        queryStringForPixel = queryStringForPixel.replacingOccurrences(of: "%3D", with: "=")
        let jsonParser = JsonParser()
        var featureString:String=""
        do{
            featureString = jsonParser.getExecute(url: queryStringForPixel)
        }catch{
            
        }
        let fsFeatureReader = McxFsFeatureReader(featureString: featureString, fields: fieldsOrdered, layer: self, world: " ", display:" ")
        let searchResult = McxSearchResult()
        searchResult.setFeatureReader(featureReader: fsFeatureReader)
        searchResult.setLayer(layer: layer)
        
        return searchResult
    }
    override func createFeatureBuffer() -> IMcxFeature? {
        return McxMemFeature(layer: self,fieldDefinition: nil)
    }
    override func search(fields: String, whereClause: String, geometry: IMcxGeometry?, relation: String, ajaxParameter: String) -> McxSearchResult {
        var fieldsOrdered:String=""
        if(fields != ""){
            let fieldsArray = fields.index(fields.startIndex, offsetBy: 1)..<fields.index(fields.endIndex, offsetBy:-1)
            fieldsOrdered = String(fields[fieldsArray])
            fieldsOrdered = fieldsOrdered.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        }
        let parameters: [String: Any] = [
            "AttributeFilter": whereClause,
            "Envelope": "", // #todo yazılıacak
            "Fields": fields,
            "Filters": "", // #todo yazılıacak
            "Geometry": geometry ?? "",
            "LayerName": self._layerServerName,
            "Token": self._credentials,
            "Relation": relation,
            "Min":-1,
            "Max":-1
        ]
        let searchStringUrl = self.fullName + "search?"
        let featureString:String = JsonParser().postExecute(url: searchStringUrl, parameters: parameters)
        let fsFeatureReader = McxFsFeatureReader(featureString: featureString, fields: fieldsOrdered, layer: self, world: " ", display:" ")
        let searchResult = McxSearchResult()
        searchResult.setFeatureReader(featureReader: fsFeatureReader)
        searchResult.setLayer(layer: self)
        
        return searchResult
    }
    func fillFieldDefinions(fieldDefJson:[Dictionary<String,Any>]) -> [IMcxFieldDefinition] {
        var fieldDefinitionArray = [IMcxFieldDefinition]()
        for i in 0..<fieldDefJson.count{
            var tempFieldObj = fieldDefJson[i]
            let fieldDefinition = McxFieldDefinition()
            fieldDefinition.setFieldName(fieldName: tempFieldObj["FieldName"] as! String)
            fieldDefinition.setFieldType(fieldType: tempFieldObj["FieldType"] as! String)
            fieldDefinition.setIsPrimaryKey(isPrimaryKey: tempFieldObj["IsPrimaryKey"] as! Bool)
            fieldDefinition.setSize(size: tempFieldObj["Size"] as! Int)
            fieldDefinitionArray.append(fieldDefinition)
        }
        return fieldDefinitionArray
    }
    func getServerLayerName() -> String {
        return self._layerServerName
    }
    func getCredentials() -> String {
        return self._credentials
    }
}
extension String
{
    func getJsonArray()-> Dictionary<String,Any>{
        var _jsonArray:Dictionary<String,Any>?=nil
        let data = self.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            {
                _jsonArray = jsonArray[0]
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        return _jsonArray!
    }
}
