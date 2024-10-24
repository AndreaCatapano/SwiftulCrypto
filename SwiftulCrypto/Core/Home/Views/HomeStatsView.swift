//
//  HomeStatsView.swift
//  SwiftulCrypto
//
//  Created by Andrea Catapano on 23/10/24.
//

import SwiftUI


struct HomeStatsView : View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showPortfolio: Bool
    
    var body: some View {
        HStack{
            ForEach(vm.statics) { stat in
                StaticView(stat: stat)
                    .frame(width: UIScreen.main.bounds.width/3)
            }
        }
        .frame(width: UIScreen.main.bounds.width,
               alignment: showPortfolio ? .trailing : .leading)
    }
}


struct HomeStatsView_Previews: PreviewProvider{
    static var previews: some View{
        HomeStatsView(showPortfolio: .constant(false))
        
    }
}
