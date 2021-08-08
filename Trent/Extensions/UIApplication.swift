//
//  UIApplication.swift
//  Trent
//
//  Created by Fynn Kiwitt on 08.08.21.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
