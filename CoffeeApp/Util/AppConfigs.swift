//
//  AppConfigs.swift
//  CoffeeApp
//
//  Created by Rıfat Mert Dolar on 18.01.2022.
//

import Foundation

struct Constants {
    static let UploadFileMB:Int = 1
    static let CONNECTION_TIMEOUT:Double = 120
}

let BASE_URL     = "https://api.sampleapis.com"

struct CoffeeAction {
    static let hotCoffeeList        = "\(BASE_URL)/coffee/hot"          //GET  parameter:""
    static let icedCoffeeList        = "\(BASE_URL)/coffee/iced"          //GET  parameter:""
}
