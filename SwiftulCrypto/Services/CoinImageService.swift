//
//  CoinImageService.swift
//  SwiftulCrypto
//
//  Created by Andrea Catapano on 22/10/24.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService{
    
    @Published var image: UIImage? = nil
    var imageSubscription : AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let folderName = "coin_images"
    private let imageName: String
    
    init(coin: CoinModel){
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage(){
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName){
            image = savedImage
            print("Retrived image from File Manager")
        }
        else {
            downloadCoinImage()
            print("Dowloanding image now")
        }
    }
    
    private func downloadCoinImage(){
        guard let url = URL(string: coin.image) else {return}
        
        imageSubscription =  NetworkingManager.download(url: url)
            .tryMap({( data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] (returnedImage) in
                guard let self = self, let dowloadedImage = returnedImage else {return}
                self.image = dowloadedImage //Salva le monete ricevute nella proprietà allCoins
                self.imageSubscription?.cancel() //Cancella la subscription per evitare memory leak
                self.fileManager.saveImage(image: dowloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
}
