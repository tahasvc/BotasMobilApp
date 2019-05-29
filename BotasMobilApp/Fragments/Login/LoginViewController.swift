//
//  LoginViewControl.swift
//  BotasMobilApp
//
//  Created by Admin on 13.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import UIKit
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG
class LoginViewController: UIViewController {
    var delegate: ViewController?
    @IBOutlet weak var kullaniciAdiText: UITextField!
    @IBOutlet weak var sifreText: UITextField!
    var loginLayer:IMcxLayer!
    public var _isLocal: Bool!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius = 20
        delegate!._isLogin = false
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login_background")!.resizableImage(withCapInsets: .zero))
        let backgroundImage = UIImageView(frame: self.view.bounds)
        backgroundImage.clipsToBounds = true
        backgroundImage.image = UIImage(named: "login_background")
        backgroundImage.contentMode = .scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    convenience init() {
        self.init(isLocal:nil)
    }
    
    init(isLocal: Bool?) {
        self._isLocal = isLocal
        super.init(nibName: "LoginFragment", bundle: nil)
    }
    
    @IBAction func girisYap(_ sender: Any) {
        let kullaniciAdi:String = kullaniciAdiText.text!
        let sifre:String = String(sifreText.text!)
        if !_isLocal{
            if(BotasMobilHelper.isNetworkConnection()){
                self.userNamePasswControl(kullaniciAdi,sifre)
            }
            
        }
        
    }
    func userNamePasswControl(_ userName:String ,_ passw:String ) -> () {
        let passMd5:String = (self.md5(passw)).uppercased()
        do{
            loginLayer = BotasMobilApplication.dataManager().getLayer(BotasMobilSettings.mcxUsersTableName)
            let fsLayer:McxFsLayer = loginLayer as! McxFsLayer
            let whereClause:String = "USERNAME='"+userName+"' AND PASSW='"+passMd5+"'"
            let reader:McxSearchResult = fsLayer.search(fields: "", whereClause: whereClause, geometry: nil, relation: "", ajaxParameter: "")
            var feature:IMcxFeature?=nil
            if reader.getFeatureReader().read() {
                feature = reader.getFeatureReader().getCurrent()
                let user:BotasMobilUser = BotasMobilUser()
                user.setUserId((feature!.getValueWithName(name: "ID"))as! Int)
                user.setUserName((feature!.getValueWithName(name:"USERNAME"))as! String)
                BotasMobilApplication.userManager=user
                delegate!._isLogin = true

            }else{
                delegate?._isLogin = false
                print("ad veya şifre hatalı")
            }
        }catch{
            
        }
    }
    func md5(_ string: String) -> String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        let messageData = string.data(using:.utf8)!
        var digestData = Data(count: length)
        
        _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
            messageData.withUnsafeBytes { messageBytes -> UInt8 in
                if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                    let messageLength = CC_LONG(messageData.count)
                    CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                }
                return 0
            }
        }
        
        let md5 = digestData.map { String(format: "%02hhx", $0) }.joined()
        
        return md5
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
