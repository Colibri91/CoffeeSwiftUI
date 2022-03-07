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
    static let ActionRowHeigth:Int = 40
    static let PageSize:Int = 20
    static let ROOT_FOLDER_NAME:String = "Coffee"
    static let ROOT_FOLDER_ID:String = ""
    static let TEMP_FOLDER_NAME:String = "upload"
    static let DEFAULT_COPY_LINK_EXPIRATION_DAY = 30
}



let BASE_URL     = "https://coffee-coffee.b3lab.org/rest/api"
let organization = "org.b3lab.coffeedepo-internet"
let uploadTaskIdentifier      = "org.b3lab.coffe-internet.backgroundtask.upload"
let downloadTaskIdentifier    = "org.b3lab.coffee-internet.backgroundtask.download"
let uploadIdentifier    = "uploadIdentifier"

struct UserAction {
    static let profileImage = "\(BASE_URL)/settings/profile-image" //GET parameter:nil
    static let user         = "\(BASE_URL)/user"                   //GET  parameter:""
    static let usage        = "\(BASE_URL)/objects/usage"          //GET  parameter:""
}
