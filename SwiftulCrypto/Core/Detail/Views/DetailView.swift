//
//  File.swift
//  SwiftulCrypto
//
//  Created by Andrea Catapano on 25/10/24.
//

import SwiftUI


struct DetailLoadingView: View {
    @Binding var coin: CoinModel?
    
    
    var body: some View {
        ZStack{
            if let coin = coin{
                DetailView(coin: coin)
            }
        }
    }
}


struct DetailView : View {
    
    let coin: CoinModel
    
    
    init(coin: CoinModel){
        self.coin = coin
    }
    
    var body: some View {
        Text(coin.name)
    }
}


struct DetailView_Preview : PreviewProvider{
    static var previews: some View{
        DetailView(coin: dev.coin)
    }
}
