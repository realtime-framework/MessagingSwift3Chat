//
//  Utils.swift
//  RTMChatSwift
//
//  Created by joao caixinha on 02/02/16.
//  Copyright © 2016 Internet Business Technologies. All rights reserved.
//

import Foundation

func jsonDictionaryFromString(_ text: String) -> NSDictionary? {
    let jsonData: Data = text.data(using: String.Encoding.utf8)!
    var dict:NSDictionary?
    do{
        dict = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
        return dict
    }catch {
        return nil
    }
}

func jsonStringFromDictionary(_ dict: NSDictionary) -> String? {
    var jsonData: Data?
    do{
        jsonData = try JSONSerialization.data(withJSONObject: dict, options: JSONSerialization.WritingOptions.prettyPrinted)
        return String(data: jsonData!, encoding: String.Encoding.utf8)
    }catch {
        return nil
    }
    
}
