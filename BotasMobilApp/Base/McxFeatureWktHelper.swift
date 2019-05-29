//
//  McxGeometryHelper.swift
//  BotasMobilApp
//
//  Created by Admin on 23.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import MapKit
class McxFeatureWktHelper {
    private var _wkbStr :String
    private var _geometryType:McxGeometryType!
    private var _coordinates:String!
    private var _coordinateSystem:String = ""
    private var _coordinateCount:Int!
    private var _stringCursor:Int = 0
    init(_ wkbStr:String) {
        _wkbStr = wkbStr
    }
    func createFromWkb() -> MKAnnotation? {
        if (_wkbStr == ""){
                return nil
        }
        
        
        var geometry:MKAnnotation?=nil
        _geometryType =  McxGeometryType.fromInteger(geometryTypeValue: Int(self.readInteger()))
        let _ = self.readNext()
        switch _geometryType {
        case .Point?:
            geometry = self.parsePoint()
        case .LineString?:
           geometry = self.parseLineString()
        case .Polygon?:
            geometry = self.parsePolygon()
        default:
            print("")
        }
        return geometry!
    }
    func parsePoint() -> MKCircle {
        let x:Double = Double(self.readInteger())
        let y:Double = Double(self.readInteger())
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: x, longitude: y)
        let point = MKCircle(center: coordinate, radius: 5.0)
        return point
    }
    func parseLineString() -> MKPolyline {
        let numberOfPoints:Int = Int(self.readInteger())
        var points = [CLLocationCoordinate2D]()
        for _ in 0..<numberOfPoints{
            let point:MKCircle = self.parsePoint()
            points.append(point.coordinate)
        }
        return MKPolyline(coordinates: points, count: points.count)
    }
    func parsePolygon() -> MKPolygon{
        let numberOfPoints:Int = Int(self.readInteger())
        var points = [CLLocationCoordinate2D]()
        
        for _ in 0..<numberOfPoints{
            let point:MKCircle = self.parsePoint()
            points.append(point.coordinate)
        }
        return MKPolygon(coordinates: points, count: points.count)
    }
    func readInteger() -> Double {
        return Double(self.readNext())!
    }
    func readNext() -> String {
        var temp:String = ""
        while _stringCursor < _wkbStr.count {
            let del = _wkbStr.charAt(at: self._stringCursor)
            if(del == " "){
                self._stringCursor += 1
                break
            }
            else{
                temp.append(String(self._wkbStr.charAt(at: self._stringCursor)))
                self._stringCursor += 1
            }
            
        }
        return temp
    }
    
}
