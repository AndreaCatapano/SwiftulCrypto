//
//  MarketDataModel.swift
//  SwiftulCrypto
//
//  Created by Andrea Catapano on 23/10/24.
//

import Foundation


//Json Data:
/*
 --request GET \
      --url https://api.coingecko.com/api/v3/global \
      --header 'accept: application/json'
 {
   "date": {
     "active_cryptocurrencies": 13690,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 1046,
     "total_market_cap": {
       "btc": 39003738.0847159,
       "eth": 803832137.207531,
       "ltc": 26721173267.5358,
       "bch": 3981159931.51342,
       "bnb": 4670513150.58714,
       "eos": 2641998753398.41,
       "xrp": 4567762968374.06,
       "xlm": 21049307801356.5,
       "link": 153517938957.199,
       "dot": 315120726481.166,
       "yfi": 324671967.610845,
       "usd": 2721226850772.63,
     },
     "total_volume": {
       "btc": 993675.225562481,
       "eth": 20478757.1519219,
       "ltc": 680759567.614816,
       "bch": 101425662.954523,
       "bnb": 118987908.244129,
       "eos": 67308643636.0751,
       "xrp": 116370202467.687,
       "xlm": 536260797157.883,
       "link": 3911085965.39774,
       "dot": 8028144848.20593,
       "yfi": 8271476.18386717,
       "usd": 69327091133.5489,
 
     },
     "market_cap_percentage": {
       "btc": 50.4465263233584,
       "eth": 14.9228066918211,
       "usdt": 3.92900641199819,
       "bnb": 3.29395203563452,
       "sol": 2.95074801328159,
       "usdc": 1.20922049263535,
       "xrp": 1.20523481041161,
       "steth": 1.18309266793764,
       "doge": 1.05778560354543,
       "ada": 0.765987294694099
     },
     "market_cap_change_percentage_24h_usd": 1.72179506060272,
     "updated_at": 1712512855
   }
 }
 
 */



struct GlobalDate: Codable {
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {

    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    enum CodingKeys : String, CodingKey{
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: {$0.key == "usd"}){
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume : String {
        if let item = totalVolume.first(where: {$0.key == "usd"}){
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance : String {
        if let item = marketCapPercentage.first(where: {$0.key == "btc"}){
            return item.value.asPercentString()
        }
        return ""
    }
}
