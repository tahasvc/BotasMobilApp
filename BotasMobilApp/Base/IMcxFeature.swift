//
//  IMcxFeature.swift
//  BotasMobilApp
//
//  Created by Admin on 29.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import MapKit
protocol IMcxFeature {
    
    func getField(ordinalName:AnyObject) -> IMcxFieldDefinition
    
    func getLayer() -> IMcxLayer
    
    func getValue(name:String) -> AnyObject
    
    func setValue(ordinalOrName:AnyObject,value:AnyObject)
    
    func setFeatureId(featureId:Int)
    
    func getFeatureId() -> Int
    
    func setGeometry(geometry:MKAnnotation) -> ()
    
    func getGeometry() -> MKAnnotation?
    
    func getValueWithName(name: String) -> AnyObject
    
    func getFieldCount() -> Int
    
    func getFieldName(ordinal:Int) -> String
    
    func convertToString(_ filterArray:[String]?) -> String 
}
