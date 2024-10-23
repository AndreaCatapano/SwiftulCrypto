//
//  Untitled.swift
//  SwiftulCrypto
//
//  Created by Andrea Catapano on 21/10/24.
//

//C CoinGecko Api Info
/*
 
URL:
 
 curl --request GET \
      --url 'https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h' \
      --header 'accept: application/json' \
      --header 'x-cg-demo-api-key: CG-weGhKemUAqF7ACr89sGFodMG    '
 
 
 JSON Response: {
 "id": "bitcoin",
 "symbol": "btc",
 "name": "Bitcoin",
 "image": "https://coin-images.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
 "current_price": 62472,
 "market_cap": 1234843829476,
 "market_cap_rank": 1,
 "fully_diluted_valuation": 1311600170421,
 "total_volume": 40883038587,
 "high_24h": 63901,
 "low_24h": 61688,
 "price_change_24h": -535.142221469003,
 "price_change_percentage_24h": -0.84933,
 "market_cap_change_24h": -10859786226.2,
 "market_cap_change_percentage_24h": -0.87178,
 "circulating_supply": 19771056,
 "total_supply": 21000000,
 "max_supply": 21000000,
 "ath": 67405,
 "ath_change_percentage": -7.34015,
 "ath_date": "2024-03-14T07:10:36.635Z",
 "atl": 51.3,
 "atl_change_percentage": 121653.77299,
 "atl_date": "2013-07-05T00:00:00.000Z",
 "roi": null,
 "last_updated": "2024-10-21T19:42:07.652Z",
 "sparkline_in_7d": {
   "price": [65793.9656245832, 65747.1920338359]
 }
 
 */

import Foundation

struct CoinModel: Identifiable, Codable {
    let id, symbol, name: String
    let image: String
    let currentPrice : Double
    let marketCap, marketCapRank, fullyDilutedValuation: Double?
    let totalVolume, high24H, low24H: Double?
    let priceChange24H, priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H: Double?
    let circulatingSupply, totalSupply, maxSupply, ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl, atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: SparklineIn7D?
    let currentHoldings : Double?
    
    
    enum CodingKeys: String, CodingKey{
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case lastUpdated = "last_updated"
        case sparklineIn7D = "sparkline_in_7d"
        case currentHoldings
    }
    
    func updateHolding(amount: Double) -> CoinModel{
        return CoinModel(id: id, symbol: symbol, name: name, image: image, currentPrice: currentPrice, marketCap: marketCap, marketCapRank: marketCapRank, fullyDilutedValuation: fullyDilutedValuation, totalVolume: totalVolume, high24H: high24H, low24H: low24H, priceChange24H: priceChange24H, priceChangePercentage24H: priceChangePercentage24H, marketCapChange24H: marketCapChange24H, marketCapChangePercentage24H: marketCapChangePercentage24H, circulatingSupply: circulatingSupply, totalSupply: totalSupply, maxSupply: maxSupply, ath: ath, athChangePercentage: athChangePercentage, athDate: athDate, atl: atl, atlChangePercentage: atlChangePercentage, atlDate: atlDate, lastUpdated: lastUpdated, sparklineIn7D: sparklineIn7D, currentHoldings: currentHoldings)
    }
    
    var currentHoldingValue : Double{
        return (currentHoldings ?? 0) * currentPrice
    }
    
    var rank: Int{
        return Int(marketCapRank ?? 0)
    }
}

struct SparklineIn7D: Codable {
    let price: [Double]?
}

