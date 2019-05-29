//
//  IMcxFeatureReader.swift
//  BotasMobilApp
//
//  Created by Admin on 29.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
protocol IMcxFeatureReader {
    func read() -> Bool
    func getCurrent() ->IMcxFeature
}
