//
//  Uri.swift
//  BotasMobilApp
//
//  Created by Admin on 25.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class Uri {
    private static var encodeStr:String=""
    static func encode(str:String) -> String {
        encodeStr = str.encodeUrl()!
        
        return encodeStr
    }
    static func decode(str:String) -> String{
        let decodeStr:String = str.decodeUrl()!
        
        return decodeStr
    }
}
extension String
{
    func encodeUrl() -> String?
    {
//        let allowedCharacterSet = (CharacterSet(charactersIn: "<>!*'();:@&=+$,/?%#[]").inverted)
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    }
    func decodeUrl() -> String?
    {
        return self.removingPercentEncoding
    }
}
