//
//  ProductListItem.swift
//  CoffeeApp
//
//  Created by Rıfat Mert Dolar on 18.01.2022.
//

import SwiftUI
import Kingfisher

struct ProductListItem: View {
    
    let content: CoffeeListModelElement
    
    var body: some View {
        HStack(){
            KFImage(URL(string: "https://coffee.alexflipnote.dev/random")!).resizable().frame(width: 40.0, height: 40.0).clipShape(Circle())
            Spacer()
            VStack(){
                Text(content.title ?? "")
                Spacer()
                Text(String(content.ingredients?.capacity ?? 0) + " ingredients")
            }
        }
    }
}

struct ProductListItem_Previews: PreviewProvider {
    static var previews: some View {
        ProductListItem(content: CoffeeListModelElement.init(title: "", coffeeListModelDescription: "", ingredients: [], id: 0))
    }
}
