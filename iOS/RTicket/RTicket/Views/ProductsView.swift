//
//  ProductsView.swift
//  RTicket
//
//  Created by Andrew Morgan on 25/02/2022.
//

import SwiftUI
import RealmSwift

struct ProductsView: View {
    @ObserveInjection var inject
    
    let username: String
    var isPreview = false
    let subscriptionName = "activeProducts"
    
    @ObservedResults(Product.self, sortDescriptor: SortDescriptor(keyPath: "productName", ascending: true)) var products
    @Environment(\.realm) var realm
    
    @State private var inProgress = false
    
    
    var body: some View {
        List {
            ForEach(products, id: \.self) { product in
                if !isPreview {
                    if let currentUser = realmApp.currentUser {
                        NavigationLink(destination: TicketsView(product: product.productName, username: username)
                            .environment(\.realmConfiguration, currentUser.flexibleSyncConfiguration())) {
                                Text(product.productName)
                            }
                    }
                } else {
                    NavigationLink(destination: TicketsView(product: product.productName, username: username, isPreview: true)) {
                        Text(product.productName)
                    }
                }
            }
        }
        .navigationBarTitle("Products", displayMode: .inline)
//        TODO: Make subscriptions work correctly
        .onAppear(perform: setSubscriptions)
                .onDisappear(perform: clearSubscriptions)
                .enableInjection()
    }
    
    private func setSubscriptions() {
        if !isPreview {
            let subscriptions = realm.subscriptions
            if subscriptions.first(named: subscriptionName) == nil {
                print("Setting up activeProducts")
                inProgress = true
                subscriptions.update() {
                subscriptions.append(QuerySubscription<Product>(name: subscriptionName) { product in
                    product.active == true
                })
                } onComplete: { _ in
                    Task { @MainActor in
                        inProgress = false
                    }
                }
            }
        }
    }
    
    private func clearSubscriptions() {
        if !isPreview {
            let subscriptions = realm.subscriptions
            print("Clearing activeProducts")
            subscriptions.update {
                subscriptions.remove(named: subscriptionName)
            } onComplete: { error in
                if let error = error {
                    print("Failed to unsubscribe for \(subscriptionName): \(error.localizedDescription)")
                }
            }
        }
    }
}

struct ProductsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProductsView(username: "Andrew",  isPreview: true)
        }
    }
}
