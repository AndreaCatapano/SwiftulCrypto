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
    
    @Published var searchText : String = ""
    
    private let dataService = CoinDataService()
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        addSubsribers()
    }
    
    
    func addSubsribers(){
         
        dataService.$allCoins
            .sink {[weak self] (returnedCoins) in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
        
        
        ///Ascolta i cambiamenti nel testo di ricerca
        ///Ogni volta che l'utente digita qualcosa, filtra la lista completa di monete
        ///Se trova corrispondenze nel nome, simbolo o ID della moneta, include quella moneta nei risultati
        ///Aggiorna automaticamente la lista visualizzata con i risultati filtrati

        $searchText
            .combineLatest(dataService.$allCoins) // Combina il testo di ricerca con un altro publisher che contiene tutte le monete (allCoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main) // Evita di fare ricerche continue nel caso in cui l'utente scriva tante lettere insieme
            .map(filterCoins) //Trasforma i dati ricevuti da combineLatest (Text + AllCoins) per avere un ritorno di Monete che hanno tra le loro proprietà il testo inserito nella ricerca 
            .sink { [weak self] (returnedCoins) in //Sottoscrive al risultato del filtro
                self?.allCoins = returnedCoins //Aggiorna la proprietà allCoins con le monete filtrate
            }
            .store(in: &cancellables) //Memorizza la sottoscrizione in una collection di cancellable
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
}
