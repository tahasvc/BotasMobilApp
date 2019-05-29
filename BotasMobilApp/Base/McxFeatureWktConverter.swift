//
//  McxFeatureWktConverter.swift
//  BotasMobilApp
//
//  Created by Admin on 23.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import MapKit
class McxFeatureWktConverter {
    func parseGeometry(geometry:MKAnnotation) -> String {
        let code:String = "0"
        
        if(geometry is MKCircle){
            return String(format:"%d %@ %@", McxGeometryType.Point.rawValue,code,self.parseCoordinate(geometry.coordinate))
        }
        if(geometry is MKPolyline){
            return  String(format:"%d %@ %@", McxGeometryType.LineString.rawValue,code,self.parseLineString(geometry as! MKPolyline))
        }
        if geometry is MKPolygon{
            return String(format:"%d %@ %@", McxGeometryType.Polygon.rawValue,code,self.parsePolygon(geometry as! MKPolygon))
        }
        return ""
    }
    
    func parseCoordinate(_ coordinate:CLLocationCoordinate2D) -> String {
        return String(coordinate.latitude) + " " + String(coordinate.longitude) + " "
        
    }
    func parseLineString(_ lineString:MKPolyline) -> String {
        var coordinates :[CLLocationCoordinate2D]=[CLLocationCoordinate2D]()
        for i in 0..<lineString.pointCount {
            coordinates.append(lineString.points()[i].coordinate)
        }
        var strBuilder:String = ""
        strBuilder.append(String(coordinates.count))
        strBuilder.append(" ")
        strBuilder.append(self.parseCoordinateList(coordinates))
        
        return strBuilder
    }
    func parseCoordinateList(_ coordinates:[CLLocationCoordinate2D]) -> String {
        var curStrBuilder:String = ""
        for coordinate in coordinates {
            curStrBuilder.append(self.parseCoordinate(coordinate))
        }
        
        return curStrBuilder
    }
    func parsePolygon(_ polygon:MKPolygon) -> String {
        var coordinates :[CLLocationCoordinate2D]=[CLLocationCoordinate2D]()
        for i in 0..<polygon.pointCount {
            coordinates.append(polygon.points()[i].coordinate)
        }
        var strBuilder:String = ""
        strBuilder.append(String(coordinates.count))
        strBuilder.append(" ")
        strBuilder.append(self.parseCoordinateList(coordinates))
        
        return strBuilder
    }
}
