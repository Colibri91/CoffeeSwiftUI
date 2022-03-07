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
                ZStack{
                    NavigationLink(destination:
                            ProductDetailScreen()
                        ) {
                            EmptyView()
                        }
                        .opacity(0.0)
                        .buttonStyle(PlainButtonStyle())
                    ProductListItem()
                }
            }
        }.listStyle(PlainListStyle())
    }.navigationBarHidden(true)
    }
}

struct ProductListScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProductListScreen()
    }
}
