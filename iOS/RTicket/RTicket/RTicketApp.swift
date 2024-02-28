//
//  RTicketApp.swift
//  RTicket
//
//  Created by Andrew Morgan on 25/02/2022.
//

import SwiftUI
import RealmSwift
@_exported import Inject // Makes Inject globally available

let realmApp = RealmSwift.App(id: "rticket-waseh") // copy the app id from the backend Realm app
let useEmailPasswordAuth = true // set to "true" if you want username/password rather than anonymous auth

@main
struct RTicketApp: SwiftUI.App {
    init() {
//        Run with the Inject library enabled
            #if DEBUG
            if let path = Bundle.main.path(forResource: "iOSInjection", ofType: "bundle") ??
                Bundle.main.path(forResource: "macOSInjection", ofType: "bundle") {
                Bundle(path: path)!.load()
            }
//        Animation for the Inject library
        Inject.animation = .easeInOut(duration: 0.5)
            #endif
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
