//
//  CoinDataService.swift
//  SwiftulCrypto
//
//  Created by Andrea Catapano on 22/10/24.
//

///Questo codice usa Combine (framework di Apple per gestire eventi asincroni) per:
///Fare una richiesta HTTP all'API di CoinGecko
///Validare la risposta
///Convertire i dati Json in oggetti Swift
///Salvare i risultati per l'uso dell'App

import Foundation
import Combine

class CoinDataService{
    
    @Published var allCoins : [CoinModel] = []
    private  var coinSubscription : AnyCancellable?
    
    init () {
        getCoins()
    }
    
    
    private func getCoins(){
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") //Viene creato un URL usando una stringa che punta all'API di CoinGecko
                
        else {return}
                
        coinSubscription =  NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())//Converte i dati JSON ricevuti in un array di oggetti CoinModel
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedCoins) in
                self?.allCoins = returnedCoins //Salva le monete ricevute nella proprietà allCoins
                self?.coinSubscription?.cancel() //Cancella la subscription per evitare memory leak
            })
    }
}
