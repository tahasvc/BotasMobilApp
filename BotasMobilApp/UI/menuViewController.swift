//
//  menuViewController.swift
//  memuDemo
//
//  Created by Parth Changela on 09/10/16.
//  Copyright © 2016 Parth Changela. All rights reserved.
//

import UIKit

class menuViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tblTableView: UITableView!
    @IBOutlet weak var imgProfile: UIImageView!
    
    var ManuNameArray:Array = [String]()
    var iconArray:Array = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ManuNameArray = ["Veri Tabanı Aç","Haritayı Kaydet","Katman Yöneticisi","Konum İle Görev Ekle","Rapor","Ayarlar","Yeniden Başlat"]
//        ManuNameArray = ["Veri Tabanı Aç","Haritayı Kaydet","Konum İle Görev Ekle","Rapor","Ayarlar","Yeniden Başlat"]

        iconArray = [UIImage(named:"open_db")!,UIImage(named:"save")!,UIImage(named:"icons8-layers")!,UIImage(named:"ic_marker")!,UIImage(named:"report")!,UIImage(named:"settings")!,UIImage(named:"reset")!]
//          iconArray = [UIImage(named:"open_db")!,UIImage(named:"save")!,UIImage(named:"ic_marker")!,UIImage(named:"report")!,UIImage(named:"settings")!,UIImage(named:"reset")!]
        imgProfile.layer.masksToBounds = false
        imgProfile.clipsToBounds = true
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ManuNameArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! MenuCell
        
        cell.lblMenuname.text! = ManuNameArray[indexPath.row]
        cell.imgIcon.image = iconArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let revealviewcontroller:SWRevealViewController = self.revealViewController()
         revealviewcontroller.revealToggle(animated: true)
        let cell:MenuCell = tableView.cellForRow(at: indexPath) as! MenuCell
        if cell.lblMenuname.text! == "Veri Tabanı Aç"
        {
            if BotasMobilLocalDataManager.isOpen{
                return
            }
            ViewController.delegate.openDbFile()
        }
        if cell.lblMenuname.text! == "Haritayı Kaydet"
        {
            if !BotasMobilLocalDataManager.isOpen{
                return
            }
        }
        if cell.lblMenuname.text! == "Katman Yöneticisi"
        {
            if !BotasMobilLocalDataManager.isOpen{
                return
            }
            let dialogViewController = LayerManagerViewController()
                ViewController.delegate.presentDialogViewController(dialogViewController, animationPattern: .slideLeftLeft)
        }
        if cell.lblMenuname.text! == "Konum İle Görev Ekle"
        {
            if !BotasMobilLocalDataManager.isOpen{
                return
            }
            ViewController.delegate.addGpsLocationTask()
        }
        if cell.lblMenuname.text! == "Rapor"
        {
            if !BotasMobilLocalDataManager.isOpen{
                return
            }
            ViewController.delegate.showReportDialog()
        }
        if cell.lblMenuname.text! == "Ayarlar"
        {
            if !BotasMobilLocalDataManager.isOpen{
                return
            }
            print("Map Tapped")
        }
        if cell.lblMenuname.text! == "Yeniden Başlat"
        {
            print("Map Tapped")
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
