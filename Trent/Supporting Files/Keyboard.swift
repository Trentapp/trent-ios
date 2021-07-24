//
//  Keyboard.swift
//  Trent
//
//  Created by Fynn Kiwitt on 23.07.21.
//

import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    let didChange = PassthroughSubject<CGFloat, Never>()
    private var _center: NotificationCenter
    private(set) var currentHeight: CGFloat = 0 {
        didSet {
            didChange.send(currentHeight)
        }
    }

    init(center: NotificationCenter = .default) {
        _center = center
        _center.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        _center.addObserver(self, selector: #selector(keyBoardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    deinit {
        _center.removeObserver(self)
    }

    @objc func keyBoardWillShow(notification: Notification) {
        KeyboardManager.shared.isKeyboardShown = true
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            currentHeight = keyboardSize.height
        }
    }

    @objc func keyBoardDidHide(notification: Notification) {
        KeyboardManager.shared.isKeyboardShown = false
        currentHeight = 0
    }
}

class KeyboardManager: ObservableObject {
    static var shared = KeyboardManager()
    
    @Published var isKeyboardShown = false
    
    init() {
        KeyboardResponder()
    }
}
