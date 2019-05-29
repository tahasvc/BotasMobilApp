//
//  ViewController.swift
//  BotasMobilApp
//
//  Created by Admin on 9.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import UIKit
import MapKit
import LiquidFloatingActionButton
import SnapKit
import LSDialogViewController
import SQLite
import FileBrowser
class ViewController: UIViewController,UINavigationBarDelegate,UINavigationControllerDelegate{
    public var _isLogin:Bool = false
    static var delegate:ViewController!
    var cells = [LiquidFloatingCell]()
    var floatingActionButton: LiquidFloatingActionButton!
    @IBOutlet weak var sabotajButton: UIButton!
    @IBOutlet weak var uygunsuzButton: UIButton!
    @IBOutlet weak var arizaButton: UIButton!
    @IBOutlet weak var bakimButton: UIButton!
    @IBOutlet weak var btnNavBar: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        ViewController.delegate = self
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.view.sendSubview(toBack:(self.navigationController?.navigationBar)!)
        if revealViewController() != nil {
            btnNavBar.addTarget(revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        }
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
        self.createFloatingButton()
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func checkOut(_ sender: Any) {
        let dialogViewController: LoginViewController = LoginViewController(isLocal: false)
        
        dialogViewController.delegate = self
        presentDialogViewController(dialogViewController)
        dialogViewController.loginButton.addTarget(self, action: #selector(isLogin), for: .touchUpInside)
    }
    
    func dismissDialog() {
        dismissDialogViewController(LSAnimationPattern.fadeInOut)
    }
    @objc func isLogin(islog: UIButton!) {
        //        self.dismissDialog()
        if _isLogin{
            let dialogViewController: CheckIOListViewController = CheckIOListViewController(checkType: McxCheckType.CheckOut)
            presentDialogViewController(dialogViewController)
            
        }
    }
    @IBAction func checkIn(_ sender: Any) {
        if !BotasMobilLocalDataManager.isOpen{
            BotasMobilHelper.showToast("Aktif veritabanı bulunamaamıştır", self)
            return
        }
        let dialogViewController: CheckIOListViewController = CheckIOListViewController(checkType: McxCheckType.CheckIn)
        presentDialogViewController(dialogViewController)
        
    }
    
    private func createFloatingButton(){
        
        cells.append(createButtonCell(iconName: "ic_marker"))
        cells.append(createButtonCell(iconName: "ic_info"))
        cells.append(createButtonCell(iconName: "ic_pan"))
        cells.append(createButtonCell(iconName: "ic_cursor"))
        cells.append(createButtonCell(iconName: "ic_zoom_in"))
        cells.append(createButtonCell(iconName: "ic_zoom_out"))
        cells.append(createButtonCell(iconName: "ic_default_marker"))
        let floatingFrame = CGRect(x: self.view.frame.width - 56 - 16, y: self.view.frame.height - 56 - 16, width: 56, height: 56)
        let floatingButton = createButton(frame:floatingFrame,style:LiquidFloatingActionButtonAnimateStyle.down)
        //floatingButton.autoresizingMask=[.flexibleRightMargin, .flexibleLeftMargin, .flexibleBottomMargin,.flexibleTopMargin]
        
        self.view.addSubview(floatingButton)
        self.floatingActionButton = floatingButton
        self.view.bringSubview(toFront: self.floatingActionButton)
        self.floatingActionButton.snp.makeConstraints { (make) in
            make.width.equalTo(56)
            make.height.equalTo(56)
            make.top.equalTo(self.view).offset(30)
            make.right.equalTo(self.view).offset(-12)
        }
    }
    private func createButtonCell(iconName: String) -> LiquidFloatingCell {
        return LiquidFloatingCell(icon: UIImage(named: iconName)!)
    }
    
    private func createButton(frame: CGRect,style: LiquidFloatingActionButtonAnimateStyle) -> LiquidFloatingActionButton {
        let floatingActionButton = LiquidFloatingActionButton(frame: frame)
        floatingActionButton.animateStyle = style
        floatingActionButton.color = UIColor.red
        floatingActionButton.dataSource = self
        floatingActionButton.delegate = self
        
        
        return floatingActionButton
    }
    func surecOlustur() {
        let layer:IMcxLayer = BotasMobilDataBaseHelper.getLocalGorevTypeLayer()
        //        MapHelper.getMap().addGestureRecognizer(BotasMobilCreateController(layer: layer))
        MapHelper.getMap().setController(BotasMobilCreateController(layer: layer))
    }
    
    func openDbFile() {
        let fileBrowser = FileBrowser()
        fileBrowser.delegate=self
        present(fileBrowser, animated: true, completion: nil)
        
        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
            BotasMobilLocalDataManager.isOpen = true
            let _ = BotasMobilApplication.localDataManager(source: file.filePath.absoluteString)
            BotasMobilApplication.localDataManager().setSourceName(file.displayName)
            BotasMobilHelper.gorevTypeControl()
            MapHelper.loadDataInMap()
        }
        
    }
    func addGpsLocationTask() {
        presentDialogViewController(GpsLocationViewController())
    }
    func showReportDialog() -> () {
        presentDialogViewController(ReportsViewController())
    }
    static func getSelf() -> UIViewController{
        return self.window.rootViewController!
    }
}
extension ViewController: LiquidFloatingActionButtonDataSource {
    func numberOfCells(_ liquidFloatingActionButton: LiquidFloatingActionButton) -> Int
    {
        return cells.count
    }
    
    func cellForIndex(_ index: Int) -> LiquidFloatingCell
    {
        return cells[index]
    }
}

extension ViewController: LiquidFloatingActionButtonDelegate {
    func liquidFloatingActionButton(_ liquidFloatingActionButton: LiquidFloatingActionButton, didSelectItemAtIndex index: Int){
        
        switch index {
        case 0:
            if !BotasMobilLocalDataManager.isOpen{
                return
            }
            self.surecOlustur()
            
        case 1:
            if !BotasMobilLocalDataManager.isOpen{
                return
            }
            MapHelper.getMap().setController(McxIdentifyController())
            
            
        case 2:
            MapHelper.getMap().setController(nil)

        case 3:
               MapHelper.getMap().setController(nil)
        case 4:
            MapHelper.zoomIn()
        case 5:
            MapHelper.zoomOut()
        case 6:
            if !BotasMobilLocalDataManager.isOpen{
                return
            }
            MapHelper.zoomFeature(BotasMobilHelper.planGeometry)
        default:
            print("tıklanmadı")
        }
        //self.floatingActionButton.close()
    }
}
