//
//  ProductListScreen.swift
//  CoffeeApp
//
//  Created by Rıfat Mert Dolar on 18.01.2022.
//

import SwiftUI

struct ProductListScreen: View {
    
    var people = ["Angela", "Juan", "Yeji","Angela", "Juan", "Yeji","Angela", "Juan", "Yeji"]
    
    @StateObject private var viewModel:ProductListViewModel =  ProductListViewModel()
    
    var body: some View {
        NavigationView {
        List {
            ForEach(viewModel.coffeeListResponse ?? []) { coffee in
                ZStack{
                    NavigationLink(destination:
                            ProductDetailScreen()
                        ) {
                            EmptyView()
                        }
                        .opacity(0.0)
                        .buttonStyle(PlainButtonStyle())
                    
                    if viewModel.coffeeListResponse != nil {
                        ProductListItem(content: coffee)
                    } else {
                        EmptyView()
                    }
                }
            }
        }.listStyle(PlainListStyle())
        }.navigationBarHidden(true).onAppear {
            viewModel.initialize()
        }
    }
}

struct ProductListScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProductListScreen()
    }
}
