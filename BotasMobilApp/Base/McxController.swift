//
//  McxController.swift
//  BotasMobilApp
//
//  Created by Admin on 10.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class McxController:UITapGestureRecognizer ,IMcxController{
    internal var _controller:IMcxController!
    func setController(_ controller:McxController) {
        self._controller = controller
    }
}
