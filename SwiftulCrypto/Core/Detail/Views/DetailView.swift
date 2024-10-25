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
    
    @StateObject var vm: DetailViewModel
    
    
    init(coin: CoinModel){
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        Text("TEXT")
    }
}


struct DetailView_Preview : PreviewProvider{
    static var previews: some View{
        DetailView(coin: dev.coin)
    }
}
