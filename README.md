# App Criptovalute 📱💰

## Descrizione del Progetto
Questa applicazione per iOS è stata sviluppata come progetto scolastico per imparare le moderne tecnologie di sviluppo mobile Apple. L'app permette agli utenti di monitorare i prezzi delle criptovalute in tempo reale, fornendo un'interfaccia pulita e intuitiva per seguire l'andamento del mercato crypto.

## Caratteristiche Principali
- 📊 Visualizzazione dei prezzi delle criptovalute in tempo reale
- 💹 Monitoraggio dell'andamento del mercato
- 💾 Persistenza dei dati locali
- 🔄 Aggiornamenti automatici dei prezzi
- 🎨 Interfaccia utente moderna e responsive

## Tecnologie Utilizzate

### Framework e Linguaggi
- **SwiftUI**: Framework moderno per la creazione dell'interfaccia utente
- **Swift**: Linguaggio di programmazione (100% Swift)
- **CoreData**: Framework per la persistenza e gestione dei dati
- **Combine**: Framework per la programmazione reattiva e gestione degli eventi asincroni

### Architettura
- **MVVM (Model-View-ViewModel)**: Pattern architetturale per separare la logica di business dall'interfaccia utente
- **Multi-threading**: Gestione delle operazioni asincrone per mantenere fluida l'esperienza utente
- **Publishers/Subscribers**: Sistema di notifiche reattivo per aggiornamenti in tempo reale

## Fonte dei Dati
I dati delle criptovalute provengono dall'**API gratuita di CoinGecko**, una delle fonti più affidabili per informazioni sul mercato delle criptovalute. 

⚠️ *Nota: I prezzi potrebbero essere leggermente ritardati rispetto al mercato in tempo reale.*

## Funzionalità Tecniche
- **Gestione asincrona**: Utilizzo di Combine per gestire le chiamate API senza bloccare l'interfaccia utente
- **Caching locale**: CoreData per salvare i dati e permettere l'uso offline dell'app
- **Aggiornamenti reattivi**: L'interfaccia si aggiorna automaticamente quando arrivano nuovi dati
- **Ottimizzazione delle performance**: Multi-threading per operazioni pesanti

## Apprendimenti del Corso
Questo progetto è stato sviluppato seguendo un corso di **@SwiftfulThinking** su YouTube, che ha fornito le basi per:
- Implementazione dell'architettura MVVM in SwiftUI
- Utilizzo avanzato di Combine per la programmazione reattiva
- Integrazione di CoreData per la persistenza dei dati
- Best practices per lo sviluppo iOS moderno

## Sviluppatore
**Andrea Catapano** - Progetto scolastico

## Note di Sviluppo
- Progetto al 100% in Swift
- Utilizzo di API REST per il recupero dei dati
- Implementazione di pattern moderni iOS
- Focus sull'esperienza utente e performance

---
