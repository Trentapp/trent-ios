//
//  File.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 31.05.21.
//

import Foundation

class UserObjectManager: ObservableObject {
    static var shared = UserObjectManager()
    
    @Published var loggedIn = false {
        didSet {
            UserDefaults.standard.set(loggedIn, forKey: "loggedIn") //Bool
        }
    }
    @Published var user: UserObject? = UserObject(name: "Fynn Kiwitt", mail: "FynnKiwitt@yahoo.de", inventory: [], address: Address(street: "Bergheimerstraße", houseNumber: "88", zipcode: "69115", city: "Heidelberg", country: "Germany"))
    
    init() {
        self.loggedIn = UserDefaults.standard.bool(forKey: "loggedIn")
    }
}
