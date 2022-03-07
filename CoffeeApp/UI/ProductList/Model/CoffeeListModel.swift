//
//  CoffeeListModel.swift
//  CoffeeApp
//
//  Created by Rıfat Mert Dolar on 7.03.2022.
//

import Foundation

// MARK: - CoffeeListModelElement
struct CoffeeListModelElement: Identifiable, Decodable {
    let title, coffeeListModelDescription: String?
    let ingredients: [String]?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case title
        case coffeeListModelDescription = "description"
        case ingredients, id
    }
}

typealias CoffeeListModel = [CoffeeListModelElement]
