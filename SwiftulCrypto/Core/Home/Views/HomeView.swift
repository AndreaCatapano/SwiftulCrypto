import SwiftUI


struct HomeView : View {
    
    @State private var showPortofolio : Bool = false
    @EnvironmentObject private var vm : HomeViewModel
    @State private var showPortofolioView: Bool = false
    
    var body: some View {
        ZStack{
            //            background layer
            Color.theme.background
                .ignoresSafeArea()
                .sheet(isPresented: $showPortofolioView, content : {
                    PortofolioView()
                        .environmentObject(vm)
                })
            
            //            content layer
            VStack{
                homeHeader
                HomeStatsView(showPortfolio: $showPortofolio)
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
                .onTapGesture {
                    if showPortofolio{
                        showPortofolioView.toggle()
                    }
                }
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
            HStack (spacing: 4){
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity(vm.sortOption == .rank || vm.sortOption == .rankReeversed ?  1.0 : 00)
                    .rotationEffect(Angle(degrees: vm.sortOption == .rank ? 0 : 180))
            }
            .onTapGesture {
                vm.sortOption = vm.sortOption == .rank ? .rankReeversed : .rank
                }
            
            Spacer()
            if showPortofolio{
                HStack (spacing: 4){
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity(vm.sortOption == .holdings || vm.sortOption == .holdingsReversed ?  1.0 : 00)
                        .rotationEffect(Angle(degrees: vm.sortOption == .holdings ? 0 : 180))
                }
                .onTapGesture {
                    vm.sortOption = vm.sortOption == .holdings ? .holdingsReversed : .holdings
                    }
            }
            HStack (spacing: 4){
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity(vm.sortOption == .price || vm.sortOption == .priceReversed ?  1.0 : 00)
                    .rotationEffect(Angle(degrees: vm.sortOption == .price ? 0 : 180))
            }
            .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
            .onTapGesture {
                vm.sortOption = vm.sortOption == .price ? .priceReversed : .price
                }
            
            Button( action: {
                withAnimation(.linear(duration: 2.0)) {
                    vm.reloadData()
                }
            }, label:{
                Image(systemName: "goforward")
            })
            .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}
