//
//  Date.swift
//  SwiftulCrypto
//
//  Created by Andrea Catapano on 28/10/24.
//

import Foundation


extension Date{
    
    //"2024-03-14T07:10:36.635Z"
    init(coinGeckoString : String){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss:SSSZ"
        let date = formatter.date(from: coinGeckoString) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    
    
    private var shortFormatter: DateFormatter{
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    func asShortDateString() -> String{
        shortFormatter.string(from: self)
    }
}
