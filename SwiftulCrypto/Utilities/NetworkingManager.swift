//
//  Network.swift
//  SwiftulCrypto
//
//  Created by Andrea Catapano on 22/10/24.
//


import Foundation
import Combine


class NetworkingManager {
    
    enum NetworkingError: LocalizedError{
        case badURLResponse(url: URL)
        case unknown
        
        
        var errorDescription: String?{
            switch self {
            case .badURLResponse(url: let url): return "[🔥]Bad Response from URL: \(url)"
            case .unknown: return "[⚠️]Unknown error occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url) // Gestisce la richiesta al url
            .subscribe(on: DispatchQueue.global(qos: .default)) // Specifica che la richiesta verrà eseguita su un thread in background per non bloccare l'interfaccia utente
            .tryMap({ try handleUrlResponse(output: $0, url: url) }) //Controlla se la response è valida quindi se è valida -> restituisce solo i data
            .receive(on: DispatchQueue.main) //Sposta l'elaborazione sul thread principale, necessario per aggiornare l'UI
            .eraseToAnyPublisher() // Semplifica la tipizzazione
    }
    
    static func handleUrlResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data{
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {  //Controlla che la risposta sia valida (codici HTTP 200-299 indicano successo)
            throw NetworkingError.badURLResponse(url: url) //Se la risposta non è valida, lancia un errore
        }
        return output.data //Se è valida, passa i dati ricevuti
    }
    
    static func handleCompletion(completion : Subscribers.Completion<Error>){
        switch completion{
        case .finished : //Se finisce con successo, non fa nulla (break)
            break
        case .failure(let error):
            print (error.localizedDescription) // Se c'è un errore, lo stampa in console
        }
    }
}
