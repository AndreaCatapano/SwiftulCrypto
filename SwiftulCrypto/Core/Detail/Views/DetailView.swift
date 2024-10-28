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
    
    @StateObject private var vm: DetailViewModel
    @State private var showFullDescription : Bool = false
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    private var spacing: CGFloat = 30
    
    init(coin: CoinModel){
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        ScrollView{
            
            VStack{
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                VStack(spacing: 20){
                    overviewTitle
                    Divider()
                    descriptionSection
                    overviewGrid
                    additionalTitle
                    Divider()
                    additionalGrid
                    websiteSection

                }
                .padding()
            }
        }
        .navigationTitle(vm.coin.name)
        .toolbar{
            
                ToolbarItem(placement: .navigationBarTrailing) {
                    navigationBarTrailingItems
            }
        }
    }
}


struct DetailView_Preview : PreviewProvider{
    static var previews: some View{
        NavigationView {
            DetailView(coin: dev.coin)

        }
    }
}


extension DetailView{
    
    private var navigationBarTrailingItems :some View{
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.secondaryText)
            CoinImageView(coin:  vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var overviewTitle : some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    
    private var additionalTitle : some View{
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundColor(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var descriptionSection : some View{
        ZStack{
            if let coinDescripition = vm.coinDescripition , !coinDescripition.isEmpty{
                VStack(alignment: .leading) {
                    Text(coinDescripition)
                        .lineLimit(showFullDescription ? nil : 3)
                        .font(.callout)
                        .foregroundColor(Color.theme.secondaryText)
                    
                    Button {
                        withAnimation(.easeInOut){
                            showFullDescription.toggle()
                        }
                    } label: {
                        Text(showFullDescription ? "Less" : "Read more..")
                            .font(.caption)
                            .fontWeight(.bold)
                            .padding(.vertical, 4)
                    }
                    .accentColor(.blue)
                }
                .frame(maxWidth:.infinity, alignment: .leading)
            }
        }
    }
    
    private var websiteSection : some View {
        ZStack{
         VStack (alignment: .leading, spacing: 20) {
                if let websiteString = vm.webSiteUrl,
                   let url = URL(string: websiteString){
                    Link("Website", destination: url)
                }
                
                if let redditString = vm.redditUrl,
                   let url = URL(string: redditString){
                    Link("Reddit", destination: url)
                }
            }
        }
        .accentColor(.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
    
    private var overviewGrid : some View{
        LazyVGrid(columns: columns, alignment: .center, spacing: spacing,pinnedViews: []) {
            ForEach(vm.overviewStatistics){ stat in
                StaticView(stat: stat)
            }
        }
    }
    
    private var additionalGrid : some View{
        LazyVGrid(columns: columns, alignment: .center, spacing: spacing,pinnedViews: []) {
            ForEach(vm.additionalStatistics){ stat in
                StaticView(stat: stat)
            }
        }
    }
}
