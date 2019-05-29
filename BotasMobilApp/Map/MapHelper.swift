//
//  MapHelper.swift
//  BotasMobilApp
//
//  Created by Admin on 11.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import MapKit
class MapHelper {
    private static var _tileRenderer: MKTileOverlayRenderer?
    private static var _mapView : MKMapView?
    public static  func openMap(view : MKMapView) -> Void{
        let template = "https://mt0.google.com/vt/x={x}&y={y}&z={z}";
        let overlay = MKTileOverlay(urlTemplate: template)
        overlay.canReplaceMapContent = true
        _tileRenderer = MKTileOverlayRenderer(tileOverlay: overlay)
        let overlays = view.overlays
        view.removeOverlays(overlays)
        //        view.add(overlay, level: .aboveLabels)
        _mapView=view
        _mapView!.showsUserLocation = false
    }
    static var tileRenderer: MKTileOverlayRenderer {
        set { self._tileRenderer = newValue }
        get { return self._tileRenderer! }
    }
    static func addPoint() {
        //        MapViewController.startPaintPoint()
    }
    static func zoomOut() {
        var region: MKCoordinateRegion = _mapView!.region
        region.span.latitudeDelta = min(region.span.latitudeDelta * 2.0, 180.0)
        region.span.longitudeDelta = min(region.span.longitudeDelta * 2.0, 180.0)
        _mapView!.setRegion(region, animated: true)
    }
    
    static func zoomIn() {
        var region: MKCoordinateRegion = _mapView!.region
        region.span.latitudeDelta = min(region.span.latitudeDelta / 2.0, 180.0)
        region.span.longitudeDelta = min(region.span.longitudeDelta / 2.0, 180.0)
        _mapView!.setRegion(region, animated: true)
    }
    static func getMap() -> MKMapView {
        return self._mapView!
    }
    static func loadDataInMap() -> () {
        self.loadBakimOnarimLayer()
        self.loadSurecLayer()
        self.loadPlanliAlanLayer()
    }
    static func addGeomtoMap(_ geometryList:[MKOverlay]){
        self._mapView?.addOverlays(geometryList)
    }
    static func addGeomToMap( _ geometry:MKOverlay){
        self._mapView?.add(geometry)
    }
    static func loadBakimOnarimLayer(){
        let bakimOnarimLayer:IMcxLayer = BotasMobilDataBaseHelper.getLocalGorevLayer()!
        let reader:IMcxFeatureReader =  bakimOnarimLayer.search().getFeatureReader()
        if reader.read() {
            let feature = reader.getCurrent()
            var geom = MKPolygon()
            geom = (feature.getGeometry() as! MKPolygon)
            addGeomToMap(geom)
        }
    }
    static func loadSurecLayer() -> () {
        let boSurecLayer:IMcxLayer = BotasMobilDataBaseHelper.getLocalSurecLayer()
        let reader = boSurecLayer.search().getFeatureReader()
        while reader.read() {
            let feature = reader.getCurrent()
            if feature.getGeometry() != nil{
                addGeomToMap(feature.getGeometry()! as! MKCircle)
            }
        }
    }
    static func loadPlanliAlanLayer(){
        let planliAlanLayer:IMcxLayer = BotasMobilApplication.localDataManager().getLayer(layerName: BotasMobilSettings.planliAlanLayer)
        let reader = planliAlanLayer.search().getFeatureReader()
        if reader.read() {
            let feature = reader.getCurrent()
            if feature.getGeometry() != nil{
                let geom = feature.getGeometry()! as! MKPolyline
                addGeomToMap(geom)
                BotasMobilHelper.planGeometry = geom
                zoomFeature(geom)
            }
        }
        
    }
    static func zoomFeature(_ geometry:MKAnnotation){
        if geometry is MKPolyline{
            let geom = geometry as! MKPolyline
            _mapView!.setVisibleMapRect(geom.boundingMapRect, edgePadding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0), animated: true)
        }else if geometry is MKPolygon{
            let geom = geometry as! MKPolygon
            _mapView!.setVisibleMapRect(geom.boundingMapRect, edgePadding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0), animated: true)
        }else if geometry is MKCircle{
            let geom = geometry as! MKCircle
            _mapView!.setVisibleMapRect(geom.boundingMapRect, edgePadding: UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0), animated: true)
        }
    }
    
}
extension MKMapView{
    func setController(_ controller :UIGestureRecognizer?) -> () {
        if controller == nil{
            self.gestureRecognizers = nil
            return 
        }
        if self.gestureRecognizers != nil{
           self.gestureRecognizers = nil
        }
        self.addGestureRecognizer(controller!)
    }
}
