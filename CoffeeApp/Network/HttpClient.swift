//
//  HttpClient.swift
//  CoffeeApp
//
//  Created by Rıfat Mert Dolar on 18.01.2022.
//

import Foundation
import UIKit


struct PutResponse:Decodable {
    let success:Bool
}
enum Result<T>
{
    case success(T)
    case failure(Error)
}

enum VoidResult {
    case success
    case failure(Error)
}

enum ContentType {
    case json
    case form
    var toContentType:String {
        switch self {
        case .json:
            return "application/json; charset=utf-8"
        default:
            return "application/x-www-form-urlencoded"
        }
    }
}

class HttpClient {
    
    
    static let shared = HttpClient()
    
    private let sessionId: String = UUID().uuidString
    private let encoder = JSONEncoder()
    
    private init(){}
    
    
    
    /* private var authenticator: Authenticator
     let sessionId: String
     private let encoder = JSONEncoder()
     
     
     init(authenticator: Authenticator) {
     
     self.authenticator = authenticator
     self.sessionId = UUID().uuidString
     }*/
    
    @discardableResult
    func call<T, U>(urlStr: String,
                    body: U?,
                    httpMethod:URLRequest.HTTPMethod = .post,
                    headerParams:[String:String]? = nil,
                    callback: @escaping (Result<T>) -> Void)
    -> URLSessionTask? where T: Decodable, U: Encodable
    {
        
        printLog(str: "Request: \(urlStr)",log: .networking)
        
        guard let url = URL(string: urlStr) else { callback(.failure(ErrorHandler.badUrl(url: urlStr)))
            return nil
        }
        
        var request = URLRequest(url: url, method: httpMethod, cachePolicy: .useProtocolCachePolicy, timeoutInterval: Constants.CONNECTION_TIMEOUT)
        
        if body != nil  && URLRequest.HTTPMethod.get != httpMethod
        {
            do {
                let encoder = JSONEncoder()
                // encoder.outputFormatting = .sortedKeys
                //let jsonBody = try encoder.encode(body)
                
                
                encoder.outputFormatting = [.sortedKeys,.withoutEscapingSlashes]
                let jsonBody = try encoder.encode(body!)
                
                printLog(str: "***------------RequestBody-------------***",log: .networking)
                printLog(str: String(data: jsonBody, encoding: .utf8) ?? "",log: .networking)
                printLog(str: "***------------------------------------***",log: .networking)
                request.httpBody =  jsonBody
                
            } catch let error {
                callback(.failure(error))
                return nil
            }
        }
        
        
        
        requestHeader(request: &request,parameters:headerParams)
        //"2021-09-28T11:58:14.00+0300"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let uiError = HttpClient.check(urlStr: urlStr, data, response, error) {
                callback(.failure(uiError))
                return
            }
            
            guard let data = data else {  return callback(.failure(ErrorHandler.noDataFound())) }
            //"yyyy-MM-dd'T'HH:mm:ss.SSZ"
            printLog(str: data.prettyPrintedJSONString ?? "",log: .networking)
            let decoder = JSONDecoder()
            if let result = try? decoder.decode(T.self, from: data) {
                callback(.success(result))
            } else {
                printError(str: "Decoding Error,\n\(urlStr)", log: .networking)
                let error = ErrorHandler.decodingError(url: urlStr)
                callback(.failure(error))
            }
        }
        
        task.resume()
        return task
        
    }
}


extension HttpClient {
    
    @discardableResult
    func put(urlStr: String,
             fileUrl: URL,
             headerParams:[String:String]? = nil,
             //backgroundTask:Bool = false,
             callback: @escaping (Result<PutResponse>) -> Void)
    -> URLSessionUploadTask?
    {
        
        printLog(str: "put.Request: \(urlStr)",log: .networking)
        
        guard let url = URL(string: urlStr) else { callback(.failure(ErrorHandler.badUrl(url: urlStr)))
            return nil
        }
        
        
        var request = URLRequest(url: url, method: .put, cachePolicy: .useProtocolCachePolicy, timeoutInterval: Constants.CONNECTION_TIMEOUT)
        
        requestHeader(request: &request,parameters:headerParams)
        
        
        let uploadTask = URLSession.shared.uploadTask(with: request, fromFile: fileUrl) { data, response, error in
            
            if let uiError = HttpClient.check(urlStr: urlStr, data, response, error) {
                callback(.failure(uiError))
                return
            }
            callback(.success(PutResponse(success: true)))
            
            /*  if let receivedError = error {
             let uiError = ErrorHandler.fromApiRequestError(error: receivedError, url: urlStr)
             callback(.failure(uiError))
             return
             }
             
             guard let httpResponse = response as? HTTPURLResponse else {
             printError(str: "Invalid HTTP response object received after an API call", log: .networking)
             let uiError = ErrorHandler.fromMessage(message: "Invalid HTTP response object received after an API call")
             callback(.failure(uiError))
             return
             }
             
             if httpResponse.statusCode < 200 || httpResponse.statusCode > 299 {
             printError(str: "Invalid HTTP response object received \(httpResponse.statusCode),\n\(urlStr)", log: .networking)
             let uiError = ErrorHandler.fromApiResponseError(response: httpResponse, data: data,  url: urlStr)
             callback(.failure(uiError))
             return
             }
             
             
             if let uiError = HttpClient.checkError(response!) {
             callback(.failure(uiError))
             return
             }
             if error != nil {
             printError(str: "\(error!.localizedDescription),\n\(urlStr)", log: .networking)
             callback(.failure(ErrorHandler.fromLoginRequestError(error: error!)))
             return;
             }
             
             callback(.success(PutResponse(success: true)))
             */
        }
        
        uploadTask.resume()
        return uploadTask
        
    }
}

extension HttpClient {

    
    func  requestHeader(_ contenType:ContentType = .json) -> [String:String]
    {
        let headers =  ["Content-Type" :contenType.toContentType]
        headers.forEach({  print("\($0) : \($1)") })
        return headers
    }
    
    
    func  requestHeader(_ contenType:ContentType = .json, parameters:[String:String]? ) -> [String:String]
    {
        var headers =  ["Content-Type" :contenType.toContentType]
        
        if parameters != nil {
            parameters!.keys.forEach { key in
                headers[key] = parameters![key]
            }
        }
        
        headers.forEach({  print("\($0) : \($1)") })
        return headers
    }
    
    private func  requestHeader( request:inout URLRequest, _ contenType:ContentType = .json, parameters:[String:String]? = nil)
    {
        request.setValue(contenType.toContentType, forHTTPHeaderField: "Accept")
        request.setValue(ContentType.json.toContentType, forHTTPHeaderField: "Content-Type")
        if parameters != nil {
            parameters!.keys.forEach({ key in
                request.setValue(parameters![key], forHTTPHeaderField: key)
            })
        }
    }
}


extension HttpClient {
    
    static func checkError(_ urlResponse: URLResponse?) -> UIError?
    {
        if let response = urlResponse as? HTTPURLResponse
        {
            if response.isResponseNOK()
            {
                printError(str: "Server error, \(response.statusCode)", log: .networking)
                return UIError(errorCode: "\(response.statusCode)", userMessage: "Server error")
            }
        }
        
        return nil
    }
}

extension HttpClient {
    @discardableResult
    func call<U>(urlStr: String,
                 body: U?,
                 httpMethod:URLRequest.HTTPMethod = .post,
                 headerParams:[String:String]? = nil,
                 callback: @escaping (VoidResult) -> Void)
    -> URLSessionTask? where U: Encodable
    {
        
        
        printLog(str: "Request: \(urlStr)",log: .networking)
        
        guard let url = URL(string: urlStr) else { callback(.failure(ErrorHandler.badUrl(url: urlStr)))
            return nil
        }
        
        var request = URLRequest(url: url, method: httpMethod, cachePolicy: .useProtocolCachePolicy, timeoutInterval: Constants.CONNECTION_TIMEOUT)
        
        if body != nil  && URLRequest.HTTPMethod.get != httpMethod
        {
            do {
                let encoder = JSONEncoder()
                // encoder.outputFormatting = .sortedKeys
                //let jsonBody = try encoder.encode(body)
                
                
                encoder.outputFormatting = [.sortedKeys,.withoutEscapingSlashes]
                let jsonBody = try encoder.encode(body!)
                
                printLog(str: "***------------RequestBody-------------***",log: .networking)
                printLog(str: String(data: jsonBody, encoding: .utf8) ?? "",log: .networking)
                printLog(str: "***------------------------------------***",log: .networking)
                request.httpBody =  jsonBody
                
            } catch let error {
                callback(.failure(error))
                return nil
            }
        }
        requestHeader(request: &request,parameters:headerParams)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let uiError = HttpClient.check(urlStr: urlStr, data, response, error) {
                callback(.failure(uiError))
                return
            }
            callback(.success)
        }
        task.resume()
        return task
        
    }
    
    
    static  func check(urlStr:String,_ data:Data?, _ response:URLResponse?, _ error:Error?) ->  UIError?{
        if let receivedError = error {
            return ErrorHandler.fromApiRequestError(error: receivedError, url: urlStr)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            printError(str: "Invalid HTTP response object received after an API call", log: .networking)
            return ErrorHandler.fromMessage(message: "Invalid HTTP response object received after an API call")
        }
        
        if httpResponse.statusCode < 200 || httpResponse.statusCode > 299 {
            printError(str: "Invalid HTTP response object received \(httpResponse.statusCode),\n\(urlStr)", log: .networking)
            return ErrorHandler.fromApiResponseError(response: httpResponse, data: data,  url: urlStr)
        }
        
        
        if let uiError = HttpClient.checkError(response!) {
            return uiError
        }
        if error != nil {
            printError(str: "\(error!.localizedDescription),\n\(urlStr)", log: .networking)
            return ErrorHandler.fromLoginRequestError(error: error!)
        }
        
        return nil
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension HttpClient {
    
    static private func check1(urlStr:String,_ data:Data?, _ response:URLResponse?, _ error:Error?) ->  UIError?{
        if let receivedError = error {
            return ErrorHandler.fromApiRequestError(error: receivedError, url: urlStr)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            printError(str: "Invalid HTTP response object received after an API call", log: .networking)
            return ErrorHandler.fromMessage(message: "Invalid HTTP response object received after an API call")
        }
        
        if httpResponse.statusCode < 200 || httpResponse.statusCode > 299 {
            printError(str: "Invalid HTTP response object received \(httpResponse.statusCode),\n\(urlStr)", log: .networking)
            return ErrorHandler.fromApiResponseError(response: httpResponse, data: data,  url: urlStr)
        }
        
        
        if let uiError = HttpClient.checkError(response!) {
            return uiError
        }
        if error != nil {
            printError(str: "\(error!.localizedDescription),\n\(urlStr)", log: .networking)
            return ErrorHandler.fromLoginRequestError(error: error!)
        }
        
        return nil
    }
    
}

extension HTTPURLResponse {
    func isResponseNOK() -> Bool {
        return !isResponseOK()
    }
    
    func isResponseOK() -> Bool {
        return (200...299).contains(self.statusCode)
    }
    func hasRequestError() -> Bool {
        return (400...499).contains(self.statusCode)
    }
    func hasServerError() -> Bool {
        return (500...599).contains(self.statusCode)
    }
}


extension URLRequest {
    
    public enum HTTPMethod: String {
        
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case delete = "DELETE"
        case head = "HEAD"
        case options = "OPTIONS"
        case trace = "TRACE"
        case connect = "CONNECT"
    }
    
    public var method: HTTPMethod? {
        get {
            
            guard let httpMethod = self.httpMethod else { return nil }
            let method = HTTPMethod(rawValue: httpMethod)
            return method
        }
        
        set {
            
            self.httpMethod = newValue?.rawValue
        }
    }
}



extension URLRequest {
    
    public init(url: URL, method: HTTPMethod, contentType: String?) {
        
        self.init(url: url)
        
        self.method = method
        self.setValue(contentType, forHTTPHeaderField: "Content-Type")
    }
    
    public init(url: URL, method: HTTPMethod, contentType: String?, body: Data?) {
        
        self.init(url: url)
        
        self.method = method
        self.setValue(contentType, forHTTPHeaderField: "Content-Type")
        self.httpBody = body
    }
    
    public init(url: URL, method: HTTPMethod, contentType: String = "application/json; charset=utf-8", cachePolicy: CachePolicy, timeoutInterval: TimeInterval) {
        
        self.init(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        
        self.method = method
        self.setValue(contentType, forHTTPHeaderField: "Content-Type")
    }
}

