//
//  ProductDetailScreen.swift
//  CoffeeApp
//
//  Created by Rıfat Mert Dolar on 18.01.2022.
//

import SwiftUI
import Kingfisher

struct ProductDetailScreen: View {
    
    let content: CoffeeListModelElement
    
    var body: some View {
        ScrollView{
            VStack(){
                KFImage(URL(string: "https://coffee.alexflipnote.dev/random")!).resizable().frame(width: .infinity, height: 500, alignment: .center)
                Spacer()
                Text(content.title ?? "")
                Text(String(content.ingredients?.capacity ?? 0) + " ingredients").padding().frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text(content.coffeeListModelDescription ?? "").padding()
            }
        }.edgesIgnoringSafeArea(.top)
    }
}

struct ProductDetailScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailScreen(content: CoffeeListModelElement.init(title: "", coffeeListModelDescription: "", ingredients: [], id: 0))
    }
}
