//
//  JsonDataParser.swift
//  AlamofireJsonData
//
//  Created by wegie on 2016/04/30.
//  Copyright © 2016年 wegie. All rights reserved.
//

import Alamofire
import JsonData

public protocol JsonDataParser {
    func parse(data: NSData) -> Result<JsonData, NSError>
}
