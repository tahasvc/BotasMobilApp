//
//  JsonParser.swift
//  BotasMobilApp
//
//  Created by Admin on 24.04.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//
import Foundation
class JsonParser{
    func getExecute(url:String) -> String {
        var responseText:String = ""
        let group = DispatchGroup()
        group.enter()
        let reqUrl = URL(string: url)
        let task=URLSession.shared.dataTask(with: reqUrl!) {(data, response, error) in
            guard let data = data else { return }
            responseText = (String(data: data, encoding: String.Encoding.utf8) as String?)!
            group.leave()
        }
        
        task.resume()
        group.wait()
        return responseText
    }
    func postExecute(url:String,parameters:[String: Any] ) -> String {
        var responseText:String = ""
        let group = DispatchGroup()
        group.enter()
        let curUrl = URL(string: url)!
        var request = URLRequest(url: curUrl)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                    print("error", error ?? "Unknown error")
                    return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            
            responseText = String(data: data, encoding: .utf8)!
            group.leave()
        }
        
        task.resume()
        group.wait()
        
        return responseText
    }
}
extension Data
{
    func toString() -> String?
    {
        return String(data: self, encoding: .utf8)
    }
}
extension Dictionary {
    func percentEscaped() -> String {
        return map { (key, value) in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
            }
            .joined(separator: "&")
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
