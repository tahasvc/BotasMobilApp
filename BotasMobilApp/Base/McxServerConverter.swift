//
//  McxServerConverter.swift
//  BotasMobilApp
//
//  Created by Admin on 22.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxServerConverter {
    class func featureToString(_ features:[IMcxFeature],_ attributeFilter:String ,_ serializedOnChange:Bool) -> String {
        var featureString:String = ""
        var fieldCount:Int = -1
        var filterArray:[String]? = nil
        if !((attributeFilter != nil) || (attributeFilter != "")){
            filterArray = attributeFilter.components(separatedBy: ",")
            fieldCount = filterArray!.count
        }
        var featureCount:Int = 0
        for  i in 0..<features.count {
            var feature:IMcxFeature = features[i]
            if(fieldCount < 0){
                fieldCount = feature.getLayer().getFieldCount()
            }
            var serialized:String = ""
            if serializedOnChange{
                serialized = McxServerConverter.getOnChangeFields(feature,filterArray!)
            }else{
                serialized = feature.convertToString(filterArray)
            }
            featureString += serialized
            featureCount+=1
        }
        
        return String(featureCount) + ";" + String(fieldCount) + ";" + featureString
    }
    class func getOnChangeFields(_ faeture:IMcxFeature ,_ filterArray:[String]) -> String
    {
        return " "
    }
}
