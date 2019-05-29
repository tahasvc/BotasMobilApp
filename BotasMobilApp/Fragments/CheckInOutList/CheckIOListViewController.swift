//
//  FileListController.swift
//  BotasMobilApp
//
//  Created by Admin on 19.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import CleanyModal
class CheckIOListViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate{
    var list = ["No\t Ekip Adı\t Görev Tipi\t Durum\t Açıklama\t Oluşturma Tarihi\t "]
    let cellReuseIdentifier = "cell"
    let _checkType:McxCheckType!
    var _features:[IMcxFeature] = [IMcxFeature]()
    @IBOutlet weak var myTableView: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    convenience init() {
        self.init(checkType:nil)
    }
    
    init(checkType: McxCheckType?) {
        self._checkType = checkType
        super.init(nibName: "CheckListFragment", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = list[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let _taskId:Int = Int(list[indexPath.row].split(separator: "\t")[0])!
        if _checkType == McxCheckType.CheckOut{
            let alert = UIAlertController(title: "İndirme İşlemi", message: "İndirmek İstediğinize Emin Misiniz ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { action in
                switch action.style{
                case .default:
                    let _ = BotasMobilCheckOutAction(taskId: _taskId).onExecute()
                case .cancel:
                    print("")
                case .destructive:
                    print("")
                }}))
            alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: { action in
                switch action.style{
                case .cancel:
                    print("cancel")
                case .default:
                    print("")
                case .destructive:
                    print("")
                }}))
            self.present(alert, animated: true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Veri Gönderme İşlemi", message: "Veri Gönderilecek Onaylıyor Musunuz ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: { action in
                switch action.style{
                case .default:
                    let _ = BotasMobilCheckInAction(feature: self._features[indexPath.row-1]).onExecute()
                case .cancel:
                    print("")
                case .destructive:
                    print("")
                }}))
            alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: { action in
                switch action.style{
                case .cancel:
                    print("cancel")
                case .default:
                    print("")
                case .destructive:
                    print("")
                }}))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        if _checkType == McxCheckType.CheckOut{
            self.fillCheckOutGrid()
        }else{
            self.fillCheckInGrid()
        }
        
        self.myTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        self.myTableView.delegate=self
        self.myTableView.dataSource=self
    }
    func fillCheckInGrid() -> () {
        let layer:IMcxLayer = BotasMobilDataBaseHelper.getLocalSurecLayer()
        let mcxChangesLayer = BotasMobilApplication.localDataManager().getLayer(layerName: "MCX_CHANGES")
        mcxChangesLayer.setKeyField(keyField: "FEATUREID")
        let cmdText :String = String(format: "TABLEID=%d AND STATE = 0 AND HISTORY_TYPE=2 OR HISTORY_TYPE=0", layer.getTableId())
        let resultReader:IMcxFeatureReader = mcxChangesLayer.search(cmdText).getFeatureReader()
        while resultReader.read() {
            let feature = resultReader.getCurrent()
            let cmdText :String = String(format: "FEATUREID=%d", feature.getFeatureId())
            let reader:IMcxFeatureReader = layer.search(cmdText).getFeatureReader()
            while reader.read(){
                let feature:IMcxFeature = reader.getCurrent()
                var cell:String = ""
                cell+=String(feature.getValueWithName(name: "FEATUREID") as! Int) + "\t "
                cell+=feature.getValueWithName(name: "ACIKLAMA") as! String + "\t "
                cell+=(feature.getValueWithName(name: "CREATE_DATE") as! String).replacingOccurrences(of: "\\", with: "") + "\t "
                cell+=(feature.getValueWithName(name: "UPDATE_DATE") as! String).replacingOccurrences(of: "\\", with: "") + "\t "
                self.list.append(cell)
                self._features.append(feature)
            }
        }
    }
    func fillCheckOutGrid() -> () {
        let layer:IMcxLayer = BotasMobilApplication.dataManager().getLayer("VIEW_BAKIM_ONARIM")
        let whereClause:String = String(format: "MEMBER_ID=%d",BotasMobilApplication.userManager.getUserId())
        let reader:IMcxFeatureReader = (layer.search(fields: "", whereClause: whereClause, geometry: nil, relation: "", ajaxParameter: "")?.getFeatureReader())!
        while reader.read() {
            let feature:IMcxFeature = reader.getCurrent()
            var cell:String = ""
            cell+=String(feature.getValueWithName(name: "TASK_FEATUREID") as! Int) + "\t "
            cell+=feature.getValueWithName(name: "TEAM_NAME") as! String + "\t "
            cell+=feature.getValueWithName(name: "TASKTYPE") as! String + "\t "
            cell+=feature.getValueWithName(name: "TASK_TYPEINT") as! String + "\t "
            cell+=feature.getValueWithName(name: "DESCRIPTION") as! String + "\t "
            cell+=(feature.getValueWithName(name: "TASK_CREATE_DATE") as! String).replacingOccurrences(of: "\\", with: "") + "\t "
            self.list.append(cell)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
