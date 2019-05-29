//
//  McxGeometryType.swift
//  BotasMobilApp
//
//  Created by Admin on 29.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
enum McxGeometryType:Int{
    case Unknown = 0
    
    case Point = 1
    
    case LineString = 2
    
    case Polygon = 3
    
    case MultiPoint = 4
    
    case MultiLineString = 5
    
    case MultiPolygon = 6
    
    case GeometryCollection = 7
    
    case None = 8
    
    
    public static func fromInteger(geometryTypeValue:Int) -> McxGeometryType {
        return McxGeometryType(rawValue: geometryTypeValue)!
    }
}
