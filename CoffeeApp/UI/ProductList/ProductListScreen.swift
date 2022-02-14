//
//  ProductListScreen.swift
//  CoffeeApp
//
//  Created by Rıfat Mert Dolar on 18.01.2022.
//

import SwiftUI

struct ProductListScreen: View {
    
    var people = ["Angela", "Juan", "Yeji","Angela", "Juan", "Yeji","Angela", "Juan", "Yeji"]
    
    var body: some View {
        NavigationView {
        List {
            ForEach(people, id: \.self) { person in
                NavigationLink(destination: ProductDetailScreen()) {
                    ProductListItem()
                }
            }
        }
    }.navigationViewStyle(DoubleColumnNavigationViewStyle())
        .padding()
    }
}

struct ProductListScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProductListScreen()
    }
}
