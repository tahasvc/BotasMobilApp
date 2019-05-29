//
//  CustomAlertViewController.swift
//  BotasMobilApp
//
//  Created by Admin on 14.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
import CleanyModal
class CustomAlertViewController:CleanyAlertViewController {
    override init(config: CleanyAlertConfig) {
        config.styleSettings[.tintColor] = .yellow
        config.styleSettings[.destructiveColor] = .blue
        super.init(config: config)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
