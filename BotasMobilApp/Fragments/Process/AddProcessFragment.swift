//
//  AddProcessFragment.swift
//  BotasMobilApp
//
//  Created by Admin on 10.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import UIKit

class AddProcessFragment:UIViewController, UINavigationControllerDelegate {
    var delegate: ViewController=ViewController.delegate
    @IBOutlet weak var sabotajButton: UIButton!
    @IBOutlet weak var arizaButton: UIButton!
    @IBOutlet weak var uygunsuzlukButton: UIButton!
    @IBOutlet weak var bakimButton: UIButton!
    @IBOutlet weak var planliButton: UIButton!
    @IBOutlet weak var plansizButton: UIButton!
    @IBOutlet weak var bakimTypeDrop: UIPickerView!
    @IBOutlet weak var aciklamaTextBox: UITextField!
    @IBOutlet weak var tespitEdildiSwitch: UISwitch!
    @IBOutlet weak var giderildiSwitch: UISwitch!
    private var _feature:IMcxFeature!
    private var _planType:Int!
    private var _mode:McxInsertMode!
    enum McxInsertMode {
        case Insert
        case Update
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // adjust height and width of dialog
        view.bounds.size.height = UIScreen.main.bounds.size.height * 0.6
        view.bounds.size.width = UIScreen.main.bounds.size.width * 0.8
        _planType = (self._feature.getValueWithName(name: "PLAN_TYPE") as! Int)
        if(_planType == 1){
            planliButton.backgroundColor = UIColor.green
        }else{
            plansizButton.backgroundColor = UIColor.green
        }
        if _mode == McxInsertMode.Update{
            self.fillData()
        }
    }
    @IBAction func sabotaClick(_ sender: Any) {
        self.resetButtonColor()
        sabotajButton.backgroundColor = BotasMobilHelper.sabotajColor
        _feature.setValue(ordinalOrName: "GOREV_TYPE" as AnyObject, value: BotasMobilGorevType.SABOTAJ.rawValue as AnyObject)
    }
    @IBAction func kaydetClick(_ sender: Any) {
        self.saveSurec()
    }
    @IBAction func arizaClick(_ sender: Any) {
        self.resetButtonColor()
        arizaButton.backgroundColor = BotasMobilHelper.arizaColor
        _feature.setValue(ordinalOrName: "GOREV_TYPE" as AnyObject, value: BotasMobilGorevType.ARIZA.rawValue as AnyObject)
    }
    @IBAction func uygunsuzlukClick(_ sender: Any) {
        self.resetButtonColor()
        uygunsuzlukButton.backgroundColor = BotasMobilHelper.uygunsuzlukColor
        _feature.setValue(ordinalOrName: "GOREV_TYPE" as AnyObject, value: BotasMobilGorevType.UYGUNSUZLUK.rawValue as AnyObject)
    }
    @IBAction func bakimClick(_ sender: Any) {
        self.resetButtonColor()
        bakimButton.backgroundColor = BotasMobilHelper.bakimColor
        _feature.setValue(ordinalOrName: "GOREV_TYPE" as AnyObject, value: BotasMobilGorevType.BAKIM.rawValue as AnyObject)
    }
    @IBAction func planliClick(_ sender: Any) {
        _feature.setValue(ordinalOrName: "PLAN_TYPE" as AnyObject, value: 1 as AnyObject)
        self.resetPlanButton()
        planliButton.backgroundColor = UIColor.green
    }
    @IBAction func plansizClick(_ sender: Any) {
        _feature.setValue(ordinalOrName: "PLAN_TYPE" as AnyObject, value: 1 as AnyObject)
        self.resetPlanButton()
        plansizButton.backgroundColor = UIColor.green
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    convenience init() {
        self.init(feature:nil,insertMode: nil)
    }
    
    init(feature: IMcxFeature?,insertMode:McxInsertMode? ) {
        self._feature = feature!
        super.init(nibName: "AddSurecFragment", bundle: nil)
        _mode = insertMode
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func fillData() -> () {
        if (_feature.getValueWithName(name: "ACIKLAMA") as! NSString) != ""{
            aciklamaTextBox.text = (_feature.getValueWithName(name: "ACIKLAMA") as! String)
        }
        if !(_feature.getValueWithName(name: "GOREV_TYPE") is NSNull){
            let gorevTypeInt:Int = Int(_feature.getValueWithName(name: "GOREV_TYPE") as! Int)
            let gorevType:BotasMobilGorevType = BotasMobilGorevType.init(rawValue: gorevTypeInt)!
            switch gorevType{
            case .ARIZA:
                arizaButton.backgroundColor = BotasMobilHelper.arizaColor
            case .BAKIM:
                bakimButton.backgroundColor = BotasMobilHelper.bakimColor
            case .SABOTAJ:
                sabotajButton.backgroundColor = BotasMobilHelper.sabotajColor
            case .UYGUNSUZLUK:
                uygunsuzlukButton.backgroundColor = BotasMobilHelper.uygunsuzlukColor
            default:
                print("")
            }
        }
        if !(_feature.getValueWithName(name: "PLAN_TYPE") is NSNull){
            let planType:Int =  _feature.getValueWithName(name: "PLAN_TYPE") as! Int
            if planType == 1{
                planliButton.backgroundColor = .green
            }
            else{
                plansizButton.backgroundColor = .green
            }
        }
        if !(_feature.getValueWithName(name: "TESPIT_EDILDI") is NSNull){
            var tespitTip:Int = _feature.getValueWithName(name: "TESPIT_EDILDI") as! Int
            if tespitTip == 1{
                tespitEdildiSwitch.isOn = true
            }
        }
        if !(_feature.getValueWithName(name: "GIDERILDI") is NSNull){
            var giderildiTip:Int = _feature.getValueWithName(name: "GIDERILDI") as! Int
            if giderildiTip == 1{
                giderildiSwitch.isOn = true
            }
        }
    }
    func resetButtonColor() {
        sabotajButton.backgroundColor = UIColor.lightGray
        arizaButton.backgroundColor = UIColor.lightGray
        uygunsuzlukButton.backgroundColor = UIColor.lightGray
        bakimButton.backgroundColor = UIColor.lightGray
    }
    func resetPlanButton() -> () {
        planliButton.backgroundColor = UIColor.lightGray
        plansizButton.backgroundColor = UIColor.lightGray
    }
    func saveSurec() -> () {
        do{
            if _feature.getValueWithName(name: "GOREV_TYPE") === (0 as AnyObject) {
                BotasMobilHelper.showToast("Lütfen Görev Türü Seçiniz",self)
                return
            }
            var  isTespit:Int = 0
            var  isGiderildi:Int = 0
            if tespitEdildiSwitch.isOn{
                isTespit = 1
            }
            if giderildiSwitch.isOn{
                isGiderildi = 1
            }
            let layer:IMcxLayer = BotasMobilDataBaseHelper.getLocalSurecLayer()
            _feature.setValue(ordinalOrName: "ACIKLAMA" as AnyObject, value:aciklamaTextBox.text as AnyObject)
            _feature.setValue(ordinalOrName: "TESPIT_EDILDI" as AnyObject, value: isTespit  as AnyObject)
            _feature.setValue(ordinalOrName: "GIDERILDI" as AnyObject, value: isGiderildi as AnyObject)
            BotasMobilDataBaseHelper.updateFeature(_feature, layer)
            if _mode == McxInsertMode.Update{
                BotasMobilHelper.showToast("Güncellendi", ViewController.delegate)
                      BotasMobilDataBaseHelper.setChangesForInsertOrUpdate(layer, _feature.getFeatureId(), McxSqliteHistoryType.Updated)
            }else{
                BotasMobilHelper.showToast("Kayıt Edildi", ViewController.delegate)
                    BotasMobilDataBaseHelper.setChangesForInsertOrUpdate(layer, _feature.getFeatureId(), McxSqliteHistoryType.Inserted)
            }
            ViewController.delegate.dismissDialog()
        }
        catch{
        }
    }
}
