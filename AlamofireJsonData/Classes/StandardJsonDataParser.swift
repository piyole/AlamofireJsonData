//
//  StandardJsonDataParser.swift
//  AlamofireJsonData
//
//  Created by wegie on 2016/04/30.
//  Copyright © 2016年 wegie. All rights reserved.
//

import Alamofire
import JsonData

public struct StandardJsonDataParser : JsonDataParser {

    private let options: NSJSONReadingOptions

    public init() {
        self.init(options: .AllowFragments)
    }

    public init(options: NSJSONReadingOptions) {
        self.options = options
    }

    public func parse(data: NSData) -> Result<JsonData, NSError> {
        let jsonData = JsonData.parse(data, options: options)
        switch jsonData {
        case .Error(let errorInfos):
            return .Failure(Error.errorWithCode(.JSONSerializationFailed, failureReason: errorInfos.error.description))
        default:
            return .Success(jsonData)
        }
    }
}
