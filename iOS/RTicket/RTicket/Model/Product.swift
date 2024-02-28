//
//  Product.swift
//  RTicket
//
//  Created by Carlos Kelley on 2/28/24.
//

import Foundation
import RealmSwift

class Product: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var productName = ""
    @Persisted var active = false
    
    convenience init(productName: String, active: Bool) {
        self.init()
        self.productName = productName
        self.active = active
    }
}

// Just for UI testing
extension Product {
    static var areProductsPopulated: Bool {
        do {
            let realm = try Realm()
            let productObjects = realm.objects(Product.self)
            return productObjects.count >= 3
        } catch {
            print("Error, couldn't read Product objects from Realm: \(error.localizedDescription)")
            return false
        }
    }
    
    static func bootstrapProducts() {
        do {
            let realm = try Realm()
            let product1 = Product(productName : "Realm", active : true)
            let product2 = Product(productName : "Spealm", active : true)
            let product3 = Product(productName : "Lealm", active : true)
            product1.productName = "Servers"
            product3.active = false
            try realm.write {
                realm.delete(realm.objects(Product.self))
                realm.add(product1)
                realm.add(product2)
                realm.add(product3)
            }
        } catch {
            print("Error, couldn't read decision objects from Realm: \(error.localizedDescription)")
        }
    }
}
