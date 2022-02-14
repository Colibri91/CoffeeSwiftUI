//
//  MyLog.swift
//  CoffeeApp
//
//  Created by Rıfat Mert Dolar on 18.01.2022.
//

import Foundation

import os.log

extension OSLog
{
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let networking = OSLog(subsystem: subsystem, category: "Networking")
    static let general    = OSLog(subsystem: subsystem, category: "General")
    static let ui         = OSLog(subsystem: subsystem, category: "UI")
    static let chunk      = OSLog(subsystem: subsystem, category: "Chunk")
    static let deepLink   = OSLog(subsystem: subsystem, category: "DeepLink")
    static let queue      = OSLog(subsystem: subsystem, category: "Queue")
    static let deInit      = OSLog(subsystem: subsystem, category: "Deinit")
    static let openID      = OSLog(subsystem: subsystem, category: "OpenID")
}

func printLog(str:String,log:OSLog = .ui) {
    
   // #if DEBUG
    DispatchQueue.global(qos: .background).async
    {
        os_log(.debug, log: log,  "\(str)")
    }
   // #endif
}


func printError(str:String, log:OSLog = .ui) {
    
   // #if DEBUG
    DispatchQueue.global(qos: .background).async
    {
            os_log(.error, log: log,  "\(str)")
    }
   // #endif
}
