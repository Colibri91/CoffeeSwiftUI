//
//  SplashScreen.swift
//  CoffeeApp
//
//  Created by Rıfat Mert Dolar on 18.01.2022.
//

import SwiftUI

struct SplashScreen: View {
    
    @State private var isActive = false
    
    var body: some View {
        NavigationView {
                   VStack(alignment: .center) {
                       Image("ic_coffee_bean")
                       NavigationLink(destination: ProductListScreen(),
                                      isActive: $isActive,
                                      label: { EmptyView() })
                   }
                   .onAppear(perform: {
                       self.gotoLoginScreen(time: 2.5)
                   })
               }
    
    }
    
    func gotoLoginScreen(time: Double) {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(time)) {
                self.isActive = true
            }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen()
    }
}
