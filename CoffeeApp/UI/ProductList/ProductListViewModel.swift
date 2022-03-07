//
//  ProductListViewModel.swift
//  CoffeeApp
//
//  Created by Rıfat Mert Dolar on 7.03.2022.
//

import Foundation

class ProductListViewModel: BaseViewModel {
    
    private let service = HttpClient.shared
    @Published var contents: CoffeeListModel?
    
     var coffeeListResponse:CoffeeListModel? {
        didSet{
            guard let coffeeListResponse = coffeeListResponse else { return  }
            contents = coffeeListResponse
        }
    }
    
}

extension ProductListViewModel {
    func initialize() {
        fetchCoffeeList()
    }
}

extension ProductListViewModel {
    
    private func fetchCoffeeList() {
        service.call(urlStr: CoffeeAction.hotCoffeeList, body: ["":""],
                     httpMethod: .get) { [weak self]  (result:Result<CoffeeListModel>) in
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.loadingState = .success
                    self?.coffeeListResponse = response
                }
            case .failure(let error):
                printError(str:error.localizedDescription,log: .ui)
                DispatchQueue.main.async {
                    self?.loadingState = .error
                    self?.error = error as? UIError
                }
            }
        }
    }
}
