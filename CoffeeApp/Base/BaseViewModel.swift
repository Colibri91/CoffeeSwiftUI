//
//  BaseViewModel.swift
//  CoffeeApp
//
//  Created by Rıfat Mert Dolar on 7.03.2022.
//

import SwiftUI


enum LoadingState {
    case success
    case error
    case loading
    case none
}

class BaseViewModel: ObservableObject
{
    var error: UIError? {
        didSet{
            printLog(str: "<<<<<<<<<   error changed  >>>>>>>>>><<", log: .ui)
            if error != nil {
                printLog(str: error!.userMessage, log: .ui)
            }
            DispatchQueue.main.async { [ self] in
                self.hasError = self.error != nil
            }
        }
    }
    @Published var loadingState:LoadingState = .none
    @Published var hasError:Bool = false
}

extension BaseViewModel{
    
    var errorText:Text {
        return  Text(errorString)
    }
    var errorTitle:Text {
        return  Text(errorTitleString)
    }
    
    var errorString:String {
        guard let error = error else { return "Error message not found" }
        return error.userMessage
    }
    var errorTitleString:String {
        guard let error = error else { return "" }
        return  error.errorCode
    }
}

