//
//  ContentView.swift
//  RTicket
//
//  Created by Andrew Morgan on 25/02/2022.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @State private var username: String?
    
    @Environment(\.realm) var realm

    
    var body: some View {
        NavigationView {
            Group {
                if let username = username {
                    if let currentUser = realmApp.currentUser {
                        ProductsView(username: username).environment(\.realmConfiguration, currentUser.flexibleSyncConfiguration())
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
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }

