//
//  DetailDataService.swift
//  SwiftulCrypto
//
//  Created by Andrea Catapano on 25/10/24.
//

import Foundation
import Combine

class CoinDetailDataService{
    
    @Published var coinDetails : CoinDataModel? = nil
    private  var coinDetailSubscription : AnyCancellable?
    let coin: CoinModel
    
    init (coin: CoinModel) {
        self.coin = coin
        getCoins()
    }
    
    
     func getCoins(){
        
         guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") //Viene creato un URL usando una stringa che punta all'API di CoinGecko
                
        else {return}
                
         coinDetailSubscription =  NetworkingManager.download(url: url)
             .decode(type: CoinDataModel.self, decoder: JSONDecoder())//Converte i dati JSON ricevuti in un array di oggetti CoinModel
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoin) in
                self?.coinDetails = returnedCoin //Salva le monete ricevute nella proprietà allCoins
                self?.coinDetailSubscription?.cancel() //Cancella la subscription per evitare memory leak
            })
    }
}
