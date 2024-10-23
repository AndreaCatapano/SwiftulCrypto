//
//  SwiftulCryptoApp.swift
//  SwiftulCrypto
//
//  Created by Andrea Catapano on 21/10/24.
//

import SwiftUI

@main
struct SwiftulCryptoApp: App {
    
    @StateObject private var vm = HomeViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
