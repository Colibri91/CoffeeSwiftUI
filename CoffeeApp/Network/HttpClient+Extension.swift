//
//  HttpClient+Extension.swift
//  CoffeeApp
//
//  Created by Rıfat Mert Dolar on 18.01.2022.
//

import Foundation
import SwiftUI

// MARK: Upload Images Create HttpBody & Request
extension HttpClient{
    
    func createBodyWithParameters(media: Media?) -> Data {
        var body = Data()
        if media != nil
        {
            let data = media!.data
            let count = data.count / MemoryLayout<Int8>.size
            body.append(media!.dataArray, count: count)
        }
        return body
    }
    func createRequest(media : Media , url : URL) -> URLRequest {
        
        var request = URLRequest(url: url)
        request.httpMethod = URLRequest.HTTPMethod.put.rawValue
        
        request.setValue(getAuthorizationValue(), forHTTPHeaderField: "Authorization")
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        let bodyData  = createBodyWithParameters(media: media)
        request.httpBody = bodyData
        
        return request
    }
}

extension HttpClient {
    
    func call(urlStr: String,
              media: Media,
              authenticator: Authenticator?,
              callback: @escaping (VoidResult) -> Void)
    -> URLSessionTask?
    {
        let theUrlStr = urlStr //"https://webhook.site/6a31ea27-7d3b-4978-ab05-4da30106c84c"
        
        guard let _ = authenticator else { callback(.failure(ErrorHandler.unAuthorized()))
            return nil
        }
        
        guard let url = URL(string: theUrlStr) else { callback(.failure(ErrorHandler.badUrl(url: urlStr)))
            return nil
        }
        
        let urlRequest = createRequest(media: media, url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            
            if let uiError = HttpClient.check(urlStr: urlStr, data, response, error) {
                callback(.failure(uiError))
                return
            }
            callback(.success)
        }
        
        task.resume()
        return task
    }
}
