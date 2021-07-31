//
//  MainViewProperties.swift
//  Trent
//
//  Created by Fynn Kiwitt on 21.07.21.
//

import Foundation
import Combine

class MainViewProperties: ObservableObject {
    static var shared = MainViewProperties()
    
    @Published var selectedItem = tabBarConfigurations[0]
    @Published var oldValue = tabBarConfigurations[0]
    @Published var showAuthentication = false
    
    @Published var showBox = false
    @Published var boxTitle = ""
    
    func showInfo(with title: String) {
        boxTitle = title
        showBox = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showBox = false
        }
    }
}
