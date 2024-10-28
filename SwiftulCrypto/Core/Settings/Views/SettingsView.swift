//
//  SettingsView.swift
//  SwiftulCrypto
//
//  Created by Andrea Catapano on 28/10/24.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURL = URL(string: "https://www.google.it/?hl=it")!
    let coingeckoURl = URL(string : "https://coingecko.com")!
    let personalURl = URL(string: "https://www.linkedin.com/in/catapanoandrea/")!
    var body: some View {
        NavigationView{
            List{
                courseSection
                coingckoSection
                developerSection
                applicationSection
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading, content: {
                    XMarkButton()
                })
            }
        }
    }
}

struct SettingsView_Previews : PreviewProvider {
    static var previews: some View{
        SettingsView()
    }
}

extension SettingsView {
    
    private var courseSection : some View {
        Section(header: Text("Switful Thinking")){
            VStack(alignment: .leading){
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This App was made by following a @SwiftfulThinking course on YouTube. It uses MVVM Architecture, Combine and CoreData.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding()
        }
    }
    
    private var coingckoSection : some View {
        Section(header: Text("CoinGecko")){
            VStack(alignment: .leading){
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko! Price may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding()
            Link("Visit CoinGecko", destination: coingeckoURl)
        }
    }
    
    private var developerSection : some View {
        Section(header: Text("Linkedin")){
            VStack(alignment: .leading){
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This App was developed by Andrea Catapano. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threding, publishers/subscribers, and data persistence")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
            }
            .padding()
            Link("Visit my Linkedin", destination: personalURl)
        }
    }
    
    private var applicationSection : some View{
        Section(header: Text("Application")){
            Link("Terms of service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
            Link("Learn more", destination: defaultURL)
        }
    }

}
