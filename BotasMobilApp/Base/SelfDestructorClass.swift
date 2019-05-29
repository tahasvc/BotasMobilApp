//
//  SelfDestructorClass.swift
//  BotasMobilApp
//
//  Created by Admin on 27.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class SelfDestructorClass
{
    var calledTimes = 0
    let MAX_TIMES=5
    static var instancesOfSelf = [SelfDestructorClass]()
    
    init()
    {
        SelfDestructorClass.instancesOfSelf.append(self)
    }
    
    class func destroySelf(object:SelfDestructorClass)
    {
        instancesOfSelf = instancesOfSelf.filter {
            $0 !== object
        }
    }
    
    deinit {
        print("Destroying instance of SelfDestructorClass")
    }
    
    func call() {
        calledTimes += 1
        print("called \(calledTimes)")
        if calledTimes > MAX_TIMES {
            SelfDestructorClass.destroySelf(object: self)
        }
    }
}
