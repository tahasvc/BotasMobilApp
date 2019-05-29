//
//  MapViewControlller.swift
//  BotasMobilApp
//
//  Created by Admin on 11.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import MapKit
class  MapViewController:UIViewController{
    @IBOutlet weak var mapView: MKMapView!
    var _tileRenderer: MKTileOverlayRenderer!
    static var lineSymbolizer:McxLineSymbolizer = McxLineSymbolizer()
    static var pointSymbolizer:McxPointSymbolizer = McxPointSymbolizer()
    static var polygonSymbolizer:McxLineSymbolizer = McxLineSymbolizer()
    override func viewDidLoad() {
        self.initMap()
        MapHelper.openMap(view: mapView)
        self._tileRenderer=MapHelper.tileRenderer
        mapView.delegate = self
        let fill = McxFill()
        fill.setColor(.red)
        let stroke=McxStroke()
        stroke.setColor(.red)
        stroke.setWidth(5)
        MapViewController.lineSymbolizer.setFill(fill)
        MapViewController.lineSymbolizer.setStroke(stroke)
    }
    private func initMap()->(){
        //        let initialRegion  = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 39.908, longitude: 32.754),
        //                                                  span: MKCoordinateSpan(latitudeDelta: 0.16405544070813249, longitudeDelta: 0.1232528799585566))
        //        mapView.region = initialRegion
        mapView.showsUserLocation = true
        //        mapView.showsCompass = true
        mapView.setUserTrackingMode(.followWithHeading, animated: true)
    }
    static func startPaintPoint(){
        
    }
    static func getSelf() -> UIViewController{
        return self.window.rootViewController!
    }
}
extension MapViewController: MKMapViewDelegate {
    // Add mapview delegate code here
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if(overlay is MKPolyline){
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = MapViewController.lineSymbolizer.getFill().getColor().withAlphaComponent(CGFloat(MapViewController.lineSymbolizer.getFill().getOpacity()))
            polylineRenderer.fillColor = MapViewController.lineSymbolizer.getStroke().getColor()
            polylineRenderer.lineWidth = CGFloat(MapViewController.lineSymbolizer.getStroke().getWidth())
            
            return polylineRenderer
        } else if (overlay is MKPolygon){
            let polygonRenderer = MKPolygonRenderer(overlay: overlay)
            polygonRenderer.strokeColor = MapViewController.polygonSymbolizer.getStroke().getColor() .withAlphaComponent(CGFloat(MapViewController.polygonSymbolizer.getFill().getOpacity()))
            polygonRenderer.lineWidth = CGFloat(MapViewController.polygonSymbolizer.getStroke().getWidth())
            
            return polygonRenderer
        }else if overlay is MKCircle{
            let pointRenderer = MKCircleRenderer(overlay: overlay)
            pointRenderer.strokeColor = MapViewController.pointSymbolizer.getStroke().getColor().withAlphaComponent(CGFloat(MapViewController.pointSymbolizer.getGraphic().getOpacity()))
            pointRenderer.fillColor = MapViewController.pointSymbolizer.getGraphic().getColor()
            pointRenderer.lineWidth = 5
            
            return pointRenderer
        }
        return self._tileRenderer
    }
}
extension UIViewController
{
    static var window : UIWindow {
        return UIApplication.shared.windows.first!
    }
    class func instantiateFromStoryboard(storyboardName: String, storyboardId: String) -> Self
    {
        return instantiateFromStoryboardHelper(storyboardName: storyboardName, storyboardId: storyboardId)
    }
    
    private class func instantiateFromStoryboardHelper<T>(storyboardName: String, storyboardId: String) -> T
    {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: storyboardId) as! T
        return controller
    }
}
