//
//  UIApplication.swift
//  SwiftulCrypto
//
//  Created by Andrea Catapano on 22/10/24.
//

import Foundation
import SwiftUI

extension UIApplication{
    
    func endEditing (){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
