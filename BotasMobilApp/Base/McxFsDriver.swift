//
//  McxServerDriver.swift
//  BotasMobilApp
//
//  Created by Admin on 19.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

class McxFsDriver :IMcxDriver{
    
    func openDataSource(source: String) -> IMcxDataSource?{
        return nil
    }
    
     func openDataSource(source:String) -> McxOpenDataSourceResult{
        let substr = source.prefix(8)
        if(substr.uppercased().elementsEqual("MFS@REST") && !substr.uppercased().elementsEqual("MFS@SOAP")){
            
        }
        var array = [String]()
        array=source.components(separatedBy: "@")
        let encodedUri = Uri.encode(str: array[2])
        let credentials :String = "credentials=" + encodedUri
        let query: String = array[4] + "/rest/json/createToken?" + credentials
        let responseText = JsonParser().getExecute(url: query)
        if(responseText==""){
            return McxOpenDataSourceResult()
        }
        let tokenArray = responseText.index(responseText.startIndex, offsetBy: 1)..<responseText.index(responseText.endIndex, offsetBy:-1)
        let token:String = String(responseText[tokenArray])
        let fsDataSource=McxFsDataSource(driver: self,source: source,token: token)
        let openDsResult=McxOpenDataSourceResult()
        openDsResult.setDataSource(dataSource: fsDataSource)
        
        return openDsResult
    }
    func getName() -> String {
        return "Mapcodex Server Driver"
    }
}
