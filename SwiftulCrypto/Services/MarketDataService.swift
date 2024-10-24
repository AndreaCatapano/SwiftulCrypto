//
//  MarketDataService.swift
//  SwiftulCrypto
//
//  Created by Andrea Catapano on 23/10/24.
//

import Foundation



import Foundation
import Combine

class MarketDataService{
    
    @Published var marketData : MarketDataModel? = nil
    
      var marketDataSubscription : AnyCancellable?
    
    init () {
        getData()
    }
    
    
    private func getData(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") //Viene creato un URL usando una stringa che punta all'API di CoinGecko
        else {return}
                
        marketDataSubscription =  NetworkingManager.download(url: url)
            .decode(type: GlobalDate.self, decoder: JSONDecoder())//Converte i dati JSON ricevuti in un array di oggetti CoinModel
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedGlobalData) in
                self?.marketData = returnedGlobalData.data//Salva i dati ricevuti da global data nella proprietà allCoins
                self?.marketDataSubscription?.cancel() //Cancella la subscription per evitare memory leak
            })
    }
}
