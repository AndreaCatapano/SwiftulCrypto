//
//  HomeViewModel.swift
//  SwiftulCrypto
//
//  Created by Andrea Catapano on 22/10/24.
//

import Foundation
import Combine

class HomeViewModel : ObservableObject{
    
    @Published var allCoins : [CoinModel] = []
    @Published var portfolioCoins : [CoinModel] = []
    @Published var statics: [StatisticModel] = []
    @Published var searchText : String = ""
    @Published var sortOption : SortOption = .holdings
    @Published var isLoading : Bool = false
    
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portofolioDataService = PortofolioDataService()
    private var cancellables = Set<AnyCancellable>()
    
    
    enum SortOption{
        case rank, rankReeversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init(){
        addSubsribers()
    }
    
    
    func addSubsribers(){
        
        coinDataService.$allCoins
            .sink {[weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        
        ///Ascolta i cambiamenti nel testo di ricerca
        ///Ogni volta che l'utente digita qualcosa, filtra la lista completa di monete
        ///Se trova corrispondenze nel nome, simbolo o ID della moneta, include quella moneta nei risultati
        ///Aggiorna automaticamente la lista visualizzata con i risultati filtrati
        
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOption) // Combina il testo di ricerca con un altro publisher che contiene tutte le monete (allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // Evita di fare ricerche continue nel caso in cui l'utente scriva tante lettere insieme
            .map(filterAndSortCoins) //Trasforma i dati ricevuti da combineLatest (Text + AllCoins) per avere un ritorno di Monete che hanno tra le loro proprietà il testo inserito nella ricerca
            .sink { [weak self] (returnedCoins) in //Sottoscrive al risultato del filtro
                self?.allCoins = returnedCoins //Aggiorna la proprietà allCoins con le monete filtrate
            }
            .store(in: &cancellables) //Memorizza la sottoscrizione in una collection di cancellable
        
        
        // Update portofolioCoins
        $allCoins
            .combineLatest(portofolioDataService.$savedEntities)
            .map{ (coinModels, portofolioEntities) ->[CoinModel] in
                coinModels
                    .compactMap { (coin) -> CoinModel? in
                        guard let entity = portofolioEntities.first(where: {$0.coinID == coin.id}) else {
                            return nil
                        }
                        return coin.updateHolding(amount: entity.amount)
                    }
            }
            .sink { [weak self] (returnedCoins) in
                guard let self = self else {return}
                self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
            }
            .store(in: &cancellables)
        
        
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink{[weak self] (returnedStas) in
                self?.statics = returnedStas
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    
     func updatePortofolio(coin: CoinModel, amount: Double) {
        portofolioDataService.updatePortofolio(coin: coin, amount: amount)
    }
    
    
    func reloadData(){
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    
    private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel]{
        var updateCoins = filterCoins(text: text, coins: coins)
        sortCoins(sort: sort, coins: &updateCoins)
        return updateCoins
    }
    
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel]{
        
        guard !text.isEmpty else{
            return coins // Se il testo di ricerca è vuoto, restituisce tutte le monete senza filtrarle
        }
        
        let lowercasedText = text.lowercased()
        
        let filterdCoins = coins.filter { (coin) -> Bool in  //Filtra le monete cercando il testo inserito in tre campi: nome, simbolo e ID
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
        return filterdCoins
    }
    
    private func sortCoins(sort: SortOption, coins: inout [CoinModel])  {
        switch sort{
        case .rank, .holdings:
             coins.sort(by: {$0.rank < $1.rank} )
        case .rankReeversed, .holdingsReversed:
             coins.sort(by: {$0.rank > $1.rank} )
        case .price:
             coins.sort(by: {$0.currentPrice < $1.currentPrice} )
        case .priceReversed:
             coins.sort(by: {$0.currentPrice > $1.currentPrice} )
        }
    }
    
    private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel]{
        switch sortOption {
        case .holdings:
            return coins.sorted(by: {$0.currentHoldingValue > $1.currentHoldingValue})
        case .holdingsReversed:
            return coins.sorted(by: {$0.currentHoldingValue < $1.currentHoldingValue})
        default:
            return coins
        }
    }
    
    
    private func mapGlobalMarketData(marketDatdaModel: MarketDataModel?, portofolioCoins: [CoinModel]) -> [StatisticModel]{
        var stats : [StatisticModel] = []
        
        guard let data = marketDatdaModel else {
            return stats
        }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portofolioValue =  portofolioCoins.map({$0.currentHoldingValue})
            .reduce(0, +)
        
        let previusValue = portofolioCoins.map{ (coin) -> Double in
            let currentValue = coin.currentHoldingValue
            let percentChange = coin.priceChangePercentage24H ?? 0 / 100
            let previusValue = currentValue / (1 + percentChange)
            return previusValue
        }
            .reduce(0, +)
        
        
        let percentChange = ((portofolioValue - previusValue) / previusValue) / 100 
        
        let porfolio = StatisticModel(title: "Portofolio Value", value: portofolioValue.asCurrencyWith2Decimals(), percentageChange: percentChange)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            btcDominance,
            porfolio
        ])
        return stats
    }
}
