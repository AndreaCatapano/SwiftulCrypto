//
//  PortofolioView.swift
//  SwiftulCrypto
//
//  Created by Andrea Catapano on 23/10/24.
//

import SwiftUI

struct PortofolioView : View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var selectedCoin: CoinModel? = nil
    @State private var quantityText: String = "".replacingOccurrences(of: ",", with: ".")
    @State private var showCheckMarker: Bool = false
        
    var body: some View {
        NavigationStack{
            ScrollView{
                VStack(alignment: .leading, spacing: 0){
                    SearchBarView(searchText: $vm.searchText)
                    coinLogoList
                    
                    if selectedCoin != nil {
                        portofolioInputeSection
                    }
                }
            }
            .navigationTitle("Edit Portofolio")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    trailingNavBarButtons
                }
            })
            .onChange(of: vm.searchText, perform:  { value in
                if value == "" {
                    removeSelectedCoin()
                }
            })
        }
    }
}


struct PortofolioView_Previews: PreviewProvider{
    static var previews: some View{
        PortofolioView()
            .environmentObject(HomeViewModel())
    }
}


extension PortofolioView {
    
    private var coinLogoList : some View{
        ScrollView(.horizontal, showsIndicators: true, content: {
            
            LazyHStack(spacing: 10){
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 75)
                        .padding(4)
                        .onTapGesture {
                            updateSelectedCoin(coin: coin)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(selectedCoin?.id == coin.id ?
                                        Color.theme.green : Color.clear,
                                        lineWidth: 1)
                        )
                    }
            }
            .frame(height: 120)
            .padding(.leading)
        })
    }
    
    private func updateSelectedCoin(coin: CoinModel){
        selectedCoin = coin
        
        if let portofolioCoin = vm.portfolioCoins.first(where: {$0.id == coin.id}),
           let amount = portofolioCoin.currentHoldings {
            quantityText = ("\(amount)")
        }
        else{
            quantityText = ""
        }
    }
    
    
    private var portofolioInputeSection : some View{
        VStack(spacing: 20){
            HStack{
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6Decimals() ?? "")
            }
            
            Divider()
            HStack{
                Text("Amount holding:")
                Spacer()
                TextField("ex 1.3", text: $quantityText)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Divider()
            HStack{
            Text("Current value:")
                Spacer()
                Text(getCurrentValue().asCurrencyWith2Decimals())
            }
        }
        .animation(.none)
        .padding()
        .font(.headline)
    }
    
    
    private var trailingNavBarButtons : some View {
        HStack(spacing: 10){
            Image(systemName: "checkmark")
                .opacity(showCheckMarker ? 1.0 : 0.0)
            Button (action: {
                saveButtonPress()
            }, label: {
                Text("Save".uppercased())
            })
            .opacity(shouldShowSaveButton ? 1.0 : 0.0)
        }
        .font(.headline)
    }
    
    private var shouldShowSaveButton: Bool {
        guard let selectedCoin = selectedCoin else { return false }
        
        guard let quantityDouble = getQuantityDouble(from: quantityText) else { return false }
        
        return selectedCoin.currentHoldings != quantityDouble
    }
    
    private func getCurrentValue () -> Double{
        if let quantity = getQuantityDouble(from: quantityText){
            return quantity * (selectedCoin?.currentPrice ?? 0)
        }
        return  0.0
    }
    
    private func saveButtonPress () {
        guard
            let coin = selectedCoin,
            let amount = getQuantityDouble(from: quantityText)
        else {return}
        
         
        // save portfolio
        vm.updatePortofolio(coin: coin, amount: amount)
        
        // show checkmark
        withAnimation(.easeIn) {
            showCheckMarker = true
            removeSelectedCoin()
        }
        
        //hide Keyboard
        UIApplication.shared.endEditing()
        
        
        // hide checkmark
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation(.easeOut){
                showCheckMarker = false
            }
        }
    }
    
    private func removeSelectedCoin(){
        selectedCoin = nil
        vm.searchText = ""
    }
    
    
    private func getQuantityDouble(from text: String) -> Double? {
        return Double(text.replacingOccurrences(of: ",", with: "."))
    }
}
