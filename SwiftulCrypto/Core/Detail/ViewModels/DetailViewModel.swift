//
//  DetailViewModel.swift
//  SwiftulCrypto
//
//  Created by Andrea Catapano on 25/10/24.
//

import Foundation
import Combine


class DetailViewModel: ObservableObject {
    
    
    private let coinDetailService : CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()
    
    
    init(coin: CoinModel){
        self.coinDetailService = CoinDetailDataService(coin: coin)
        self.addSubscribers()
    }
    
    private func addSubscribers(){
        
        coinDetailService.$coinDetails
            .sink { (returnedCoidDetails) in
                print("RECEIVED COIN DETAIL DATA")
                print(returnedCoidDetails)
            }
            .store(in: &cancellables)
        
    }
}
