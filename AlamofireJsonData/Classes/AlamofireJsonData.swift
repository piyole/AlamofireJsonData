//
//  AlamofireJsonData.swift
//  AlamofireJsonData
//
//  Created by wegie on 2016/04/30.
//  Copyright © 2016年 wegie. All rights reserved.
//

import Alamofire
import JsonData

extension Request {

    public func responseJsonData(queue queue: dispatch_queue_t? = nil,
                                       parser: JsonDataParser,
                                       rootKey: String? = nil,
                                       completionHandler: Response<JsonData, NSError> -> Void) -> Self {
        return response(queue: queue, responseSerializer: Request.JsonDataResponseSerializer(parser)) { response in
            completionHandler(response.copyWithMap {
                let jsonData = rootKey == nil ? $0 : $0[rootKey!]
                switch jsonData {
                case .Error(let errorInfos):
                    return .Failure(Error.errorWithCode(.JSONSerializationFailed, failureReason: errorInfos.error.description))
                default:
                    return .Success(jsonData)
                }
                })
        }
    }

    public func responseJsonData(queue queue: dispatch_queue_t? = nil,
                                       options: NSJSONReadingOptions = .AllowFragments,
                                       rootKey: String? = nil,
                                       completionHandler: Response<JsonData, NSError> -> Void) -> Self {
        return responseJsonData(queue: queue, parser: StandardJsonDataParser(options: options), rootKey: rootKey, completionHandler: completionHandler)
    }

}


extension Request {

    public func responseObject<T where T : Objectable, T == T.ObjectType>(queue queue: dispatch_queue_t? = nil,
                               parser: JsonDataParser,
                               rootKey: String? = nil,
                               completionHandler: Response<T, NSError> -> Void) -> Self {
        return responseJsonData(queue: queue, parser: parser, rootKey: rootKey) { response in
            completionHandler(response.copyWithMap {
                let box = T.boxing($0)
                switch box {
                case .Boxing(let item):
                    return .Success(item)
                case .Error(let errorInfos):
                    return .Failure(Error.errorWithCode(.JSONSerializationFailed, failureReason: errorInfos.error.description))
                }
                })

        }
    }

    public func responseObject<T where T : Objectable, T == T.ObjectType>(queue queue: dispatch_queue_t? = nil,
                               options: NSJSONReadingOptions = .AllowFragments,
                               rootKey: String? = nil,
                               completionHandler: Response<T, NSError> -> Void) -> Self {
        return responseObject(queue: queue, parser: StandardJsonDataParser(options: options), rootKey: rootKey, completionHandler: completionHandler)
    }

}

extension Request {

    public func responseObject<T where T : Objectable, T == T.ObjectType>(queue queue: dispatch_queue_t? = nil,
                               parser: JsonDataParser,
                               rootKey: String? = nil,
                               completionHandler: Response<[T], NSError> -> Void) -> Self {
        return responseJsonData(queue: queue, parser: parser, rootKey: rootKey) { response in
            completionHandler(response.copyWithMap {
                let box = [T].boxing($0)
                switch box {
                case .Boxing(let item):
                    return .Success(item)
                case .Error(let errorInfos):
                    return .Failure(Error.errorWithCode(.JSONSerializationFailed, failureReason: errorInfos.error.description))
                }
                })
        }
    }

    public func responseObject<T where T : Objectable, T == T.ObjectType>(queue queue: dispatch_queue_t? = nil,
                               options: NSJSONReadingOptions = .AllowFragments,
                               rootKey: String? = nil,
                               completionHandler: Response<[T], NSError> -> Void) -> Self {
        return responseObject(queue: queue, parser: StandardJsonDataParser(options: options), rootKey: rootKey, completionHandler: completionHandler)
    }

}

extension Request {

    private static func JsonDataResponseSerializer(parser: JsonDataParser) -> ResponseSerializer<JsonData, NSError> {
        return ResponseSerializer { request, response, data, error in

            //// Copy from JSONResponseSerializer (delete 204 status logic) ////
            guard error == nil else { return .Failure(error!) }

            guard let validData = data where validData.length > 0 else {
                let failureReason = "JSON could not be serialized. Input data was nil or zero length."
                let error = Error.errorWithCode(.JSONSerializationFailed, failureReason: failureReason)
                return .Failure(error)
            }
            //// Copy from JSONResponseSerializer (delete 204 status logic) ////

            return parser.parse(validData)
        }
    }

}

extension Response {

    private static func of<U, E where E : Swift.ErrorType>(response: Response, result: Result<U, E>) -> Response<U, E> {
        return Response<U, E>(request: response.request,
                              response: response.response,
                              data: response.data,
                              result: result,
                              timeline: response.timeline)
    }

    private func copyWithMap<U>(f: Value -> Result<U, Error>) -> Response<U, Error> {
        switch result {
        case .Success(let value):
            return Response.of(self, result: f(value))
        case .Failure(let error):
            return Response.of(self, result: .Failure(error))
        }
    }
    
}

