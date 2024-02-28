//
//  ContentView.swift
//  RTicket
//
//  Created by Andrew Morgan on 25/02/2022.
//

import SwiftUI
import RealmSwift
import Inject

struct ContentView: View {
    @ObserveInjection var inject // first piece to enable injection
    @State private var username: String?
    
//    TODO: Do I need this here?
    @Environment(\.realm) var realm

    
    var body: some View {
        NavigationView {
            Group {
                if let username = username {
                    if let currentUser = realmApp.currentUser {
                        ProductsView(username: username).environment(\.realmConfiguration, currentUser.flexibleSyncConfiguration()) // pass down the user's realm configuration
                    }
                    } else {
                        if useEmailPasswordAuth {
                            EmailLoginView(username: $username)
                        } else {
                            LoginView(username: $username)
                        }
                    }
                }
                    .navigationBarItems(trailing: username != nil && useEmailPasswordAuth ? LogoutButton(username: $username) : nil)
            }
        .enableInjection() // 2nd piece to enable injection
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

