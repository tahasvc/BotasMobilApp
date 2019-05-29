//
//  LayerManagerViewController.swift
//  BotasMobilApp
//
//  Created by Admin on 24.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import MapKit
class LayerManagerViewController: UIViewController {
    var panGesture = UIPanGestureRecognizer()
    var delegate:MapViewController?
    @IBOutlet weak var polygonVisible: UIButton!
    @IBOutlet weak var pointVisible: UIButton!
    @IBOutlet weak var lineVisible: UIButton!
    @IBOutlet weak var polygonOpacity: UISlider!
    @IBOutlet weak var pointOpacity: UISlider!
    @IBOutlet weak var lineOpacity: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 20
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.draggedView(_:)))
        self.view.addGestureRecognizer(panGesture)
    }
    @IBAction func lineOpacityChange(_ sender: UISlider) {
        for item in MapHelper.getMap().overlays{
            if item is MKPolyline{
                MapViewController.lineSymbolizer.getFill().setOpacity(Double(sender.value))
                MapHelper.getMap().remove(item)
                MapHelper.getMap().add(item)
            }
        }
    }
    @IBAction func polygonOpacityChange(_ sender: UISlider) {
        for item in MapHelper.getMap().overlays{
            if item is MKPolygon{
                MapViewController.polygonSymbolizer.getFill().setOpacity(Double(sender.value))
                MapHelper.getMap().remove(item)
                MapHelper.getMap().add(item)
            }
        }
    }
    @IBAction func lineVisibleClick(_ sender: Any) {
    }
    @IBAction func pointOpacityChange(_ sender: UISlider) {
        for item in MapHelper.getMap().overlays{
            if item is MKCircle{
                MapViewController.pointSymbolizer.getGraphic().setOpacity(Double(sender.value))
                MapHelper.getMap().remove(item)
                MapHelper.getMap().add(item)
            }
        }
    }
    @IBAction func pointVisibleClick(_ sender: Any) {
    }
    
    @IBAction func polygonVisibleClick(_ sender: Any) {
    }
    @objc func draggedView(_ sender:UIPanGestureRecognizer){
        self.view.bringSubview(toFront: self.view)
        let translation = sender.translation(in: self.view)
        self.view.center = CGPoint(x: self.view.center.x + translation.x, y: self.view.center.y + translation.y)
        sender.setTranslation(CGPoint.zero, in: self.view)
    }
}
extension LayerManagerViewController: MKMapViewDelegate {
    // Add mapview delegate code here
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if(overlay is MKPolyline){
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.5)
            polylineRenderer.lineWidth = 105
            
            return polylineRenderer
        } else if (overlay is MKPolygon){
            let polygonRenderer = MKPolygonRenderer(overlay: overlay)
            polygonRenderer.strokeColor = UIColor.red.withAlphaComponent(0.5)
            polygonRenderer.lineWidth = 5
            
            return polygonRenderer
        }
        return delegate!._tileRenderer
    }
}
