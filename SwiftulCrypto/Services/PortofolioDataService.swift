//
//  PortofolioDataService.swift
//  SwiftulCrypto
//
//  Created by Andrea Catapano on 24/10/24.
//

import Foundation
import CoreData

class PortofolioDataService{
    
    private let container : NSPersistentContainer
    private let containerName : String = "PortofolioContainer"
    private let entityName : String = "PortofolioEntity"
    
    @Published var savedEntities : [PortofolioEntity] = []
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores{(_ , error) in
            if let error = error {
                print ("Error loading Core Data \(error)")
            }
            self.getPortofolio()
        }
    }
        
    // MARK: PUBLIC
    
    func updatePortofolio(coin: CoinModel, amount: Double){
        
        // check if coin is alredy in portofolio
        if let entity = savedEntities.first(where: { $0.coinID == coin.id}){
            
            if amount > 0 {
                update(entity: entity, amount: amount)
            }
            else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }

    }
    
    
    // MARK: PRIVATE
    
    // Recupera le entità salvate dal PortofolioContainer -> CoreData
    private func getPortofolio() {
        let request = NSFetchRequest<PortofolioEntity>(entityName: entityName)
        do {
            savedEntities =  try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portofolio Entities \(error)")
        }
    }
    
    // Aggiunge una nuova moneta
    private func add(coin: CoinModel, amount: Double){
        let entity = PortofolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        print("\(amount)")
        applyChanges()
    }
    
    
    // Aggiorna l'importo di una moneta esistente
    private func update(entity: PortofolioEntity, amount: Double){
        entity.amount = amount
        print("\(amount)")
        applyChanges()
    }
    
    //Rimuove una moneta
    private func delete(entity: PortofolioEntity){
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    // Salva le modifiche nel contesto di CoreData
    private func save(){
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data. \(error)")
        }
    }
    
    //Combina save() e getPortofolio() per mantenere i dati sincronizzati
    private func applyChanges(){
        save()
        getPortofolio()
    }
}
