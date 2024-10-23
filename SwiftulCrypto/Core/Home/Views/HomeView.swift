import SwiftUI


struct HomeView : View {
    
    @State private var showPortofolio : Bool = false
    @EnvironmentObject private var vm : HomeViewModel
    
    var body: some View {
        ZStack{
            //            background layer
            Color.theme.background
                .ignoresSafeArea()
            
            //            content layer
            VStack{
                homeHeader
                
                SearchBarView(searchText: $vm.searchText)
                
                columnTitles
                
                if !showPortofolio{
                    allCoinsList
                    .transition(.move(edge: .leading))
                }
                
                if showPortofolio{
                    portofolioCoinsList
                        .transition(.move(edge: .trailing))
                }
                
                Spacer (minLength: 0)
            }
        }
    }
}



struct HomeView_Prreviews: PreviewProvider{
    static var previews: some View{
        HomeView()
            .navigationBarHidden(true)
            .environmentObject(dev.homeVM)
    }
}


extension HomeView {
    
    private var homeHeader : some View{
        HStack{
            CircleButtonView(iconName: showPortofolio ? "plus" : "info")
                .background(
                    CircleButtonAnimationView(animate: $showPortofolio)
                )
                .animation(.none, value: showPortofolio)
            
            Spacer()
            Text(showPortofolio ? "Portofolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.none, value: showPortofolio)
            
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortofolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()){
                        showPortofolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    
    private var allCoinsList : some View{
        List{
            ForEach(vm.allCoins){ coin in
                CoinRowView(coin: coin, showHoldingColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10,trailing: 0))
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var portofolioCoinsList : some View{
        List{
            ForEach(vm.portfolioCoins){ coin in
                CoinRowView(coin: coin, showHoldingColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10,trailing: 0))
            }
        }
        .listStyle(PlainListStyle())
    }

    private var columnTitles : some View{
        HStack{
            Text("Coin")
            Spacer()
            if showPortofolio{
                Text("Holdings")
            }
            Text("Price")
                .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
