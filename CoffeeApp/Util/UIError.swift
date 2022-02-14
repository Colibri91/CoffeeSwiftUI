//
//  UIError.swift
//  CoffeeApp
//
//  Created by Rıfat Mert Dolar on 18.01.2022.
//

import Foundation

class UIError: Error,CustomStringConvertible
{
    var description: String {
        "errorCode : \(errorCode), userMessage : \(userMessage), statusCode : \(statusCode), details : \(details)"
    }
    
    
    var errorCode: String
    var userMessage: String
    var statusCode: Int
    var details: String
    var url: String
    let stack: [String]

    init(errorCode: String, userMessage: String) {
        self.errorCode = errorCode
        self.userMessage = userMessage
        self.statusCode = 0
        self.details = ""
        self.url = ""
        self.stack = Thread.callStackSymbols
    }
    
}
