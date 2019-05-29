//
//  IMcxPointSymbolizer.swift
//  BotasMobilApp
//
//  Created by Admin on 24.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
protocol IMcxPointSymbolizer:IMcxSymbolizer {
    func getGraphic() -> IMcxGraphic
    
    func setGraphic(_ graphic:IMcxGraphic) -> ()
    
    func getStroke() -> IMcxStroke
    
    func setStroke(_ stroke:IMcxStroke) -> ()
}
