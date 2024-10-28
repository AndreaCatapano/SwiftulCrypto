//
//  String.swift
//  SwiftulCrypto
//
//  Created by Andrea Catapano on 24/10/24.
//

import Foundation

extension String {
    func toDouble() -> Double? {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US") // Usa "en_US" per il punto come separatore decimale
        formatter.numberStyle = .decimal
        return formatter.number(from: self)?.doubleValue
    }
    
    
    var removingHTMLOccurances: String{
        self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}



