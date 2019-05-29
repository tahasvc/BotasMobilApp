//
//  BotasMobilHelper.swift
//  BotasMobilApp
//
//  Created by Admin on 11.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import MapKit
import Alamofire
import Toast_Swift
import JGProgressHUD
class BotasMobilHelper{
    static var delegate:ViewController!
    static let sabotajColor:UIColor = hexStringToUIColor(hex: "#009688")
    static let arizaColor:UIColor = hexStringToUIColor(hex: "#FFA219")
    static let uygunsuzlukColor:UIColor = hexStringToUIColor(hex: "#C73C32")
    static let bakimColor:UIColor = hexStringToUIColor(hex: "#99B4D1")
    static var hud:JGProgressHUD!
    static var planGeometry:MKPolyline!
    class func isNetworkConnection() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
    class func getDataDirPath() -> String{
        var url:String = ""
        do{
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let urlString = documentDirectory.absoluteString.replacingOccurrences(of: "file://", with: "") + BotasMobilSettings.dataDirPathName
            url = urlString
            var isDirectory = ObjCBool(true)
            if FileManager.default.fileExists(atPath:urlString, isDirectory: &isDirectory) {
                
            } else {
                try FileManager.default.createDirectory(atPath: url, withIntermediateDirectories: false, attributes: nil)
            }
        }catch{
            
        }
        return url
    }
    class func gorevTypeControl() -> () {
        let layer:IMcxLayer = BotasMobilDataBaseHelper.getLocalGorevTypeLayer()
        let reader:IMcxFeatureReader = (layer.search(fields: "", whereClause: "", geometry: nil, relation: "", ajaxParameter: "")?.getFeatureReader())!
        while reader.read() {
            let feature:IMcxFeature = reader.getCurrent()
            let gorevType:Int = feature.getValueWithName(name: "GOREV_TIP") as! Int
            if gorevType == BotasMobilGorevType.SABOTAJ.rawValue{
                self.setButtonColor(ViewController.delegate.sabotajButton,sabotajColor)
            }else if gorevType == BotasMobilGorevType.ARIZA.rawValue{
                self.setButtonColor(ViewController.delegate.arizaButton,arizaColor)
            }else if gorevType == BotasMobilGorevType.UYGUNSUZLUK.rawValue{
                self.setButtonColor(ViewController.delegate.uygunsuzButton,uygunsuzlukColor)
            }else if gorevType == BotasMobilGorevType.BAKIM.rawValue{
                self.setButtonColor(ViewController.delegate.bakimButton,bakimColor)
            }
            
        }
    }
    static func setButtonColor(_ btn:UIButton,_ color:UIColor) {
        btn.backgroundColor = color
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    class func createTaskGeometry(coordinate:CLLocationCoordinate2D){
        let planType:Int = 1
        let alert = UIAlertController(title: "Süreç", message: "Belirtilen Noktada Bir İşlem Başlatmak İstediğinize Emin Misiniz ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Hayır", style: .cancel, handler: { action in
            switch action.style{
            case .cancel:
                return
            case .default:
                return
            case .destructive:
                return
            }}))
        alert.addAction(UIAlertAction(title: "Evet", style: .default, handler: { action in
            switch action.style{
            case .cancel:
                return
            case .default:
                addActionTask(planType,coordinate)
            case .destructive:
                return
            }}))
        ViewController.delegate.present(alert, animated: true, completion: nil)
    }
    private class func addActionTask(_ planType:Int ,_ coordinate:CLLocationCoordinate2D){
        
        if !(BotasMobilHelper.planGeometry.intersects(MKCircle(center: coordinate, radius: 5.0).boundingMapRect)){
            BotasMobilHelper.showToast("Attığınız Nokta Boru Hattı Üzerinde Değildir", ViewController.delegate)
            return
        }
        let gorevLayer:IMcxLayer = BotasMobilDataBaseHelper.getLocalGorevLayer()!
        let surecLayer:IMcxLayer = BotasMobilDataBaseHelper.getLocalSurecLayer()
        var surecFeature:IMcxFeature?=nil
        let reader:IMcxFeatureReader = gorevLayer.search().getFeatureReader()
        if reader.read(){
            let feature:IMcxFeature = reader.getCurrent()
            surecFeature = surecLayer.createFeatureBuffer()
            let point = MKCircle(center: coordinate, radius: 5.0)
            surecFeature?.setGeometry(geometry: point)
            surecFeature?.setValue(ordinalOrName: "GLOBALID" as AnyObject, value: (UUID().uuidString as AnyObject))
            surecFeature?.setValue(ordinalOrName: "BAKIMONARIM_REF" as AnyObject, value: feature.getValueWithName(name: "GLOBALID"))
            surecFeature?.setValue(ordinalOrName: "PLAN_TYPE" as AnyObject, value: planType as AnyObject)
            surecFeature?.setValue(ordinalOrName: "CREATE_DATE" as AnyObject, value: createDate() as AnyObject)
            BotasMobilDataBaseHelper.insertFeature(surecFeature! , surecLayer)
            MapHelper.addGeomToMap(surecFeature?.getGeometry() as! MKOverlay)
        }
        let readerCurrent:IMcxFeatureReader = surecLayer.search("GLOBALID='" + (surecFeature?.getValueWithName(name: "GLOBALID") as! String) + "'").getFeatureReader()
        if readerCurrent.read(){
            let current = readerCurrent.getCurrent()
            surecFeature = current
        }
        let surecFragmentController = AddProcessFragment(feature: surecFeature,insertMode: .Insert)
        ViewController.delegate.presentDialogViewController(surecFragmentController)
    }
    class func showToast(_ text:String,_ viewCtrl:UIViewController) -> () {
        var style = ToastStyle()
        style.messageColor = .white
        ToastManager.shared.style = style
        ToastManager.shared.isTapToDismissEnabled = true
        ToastManager.shared.isQueueEnabled = true
        viewCtrl.view.makeToast(text)
    }
    
    class func showSpinner() {
        hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Lütfen Bekleyiniz..."
        hud.show(in: ViewController.delegate.view)
        
    }
    
    class func removeSpinner() {
        hud.dismiss(afterDelay: 0.5)
    }
    class func createDate() -> String{
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd-MM-yyyy HH:mm"
        let date:String =  dateFormatterPrint.string(from: Date())
        
        return date.datatypeValue
    }
}

