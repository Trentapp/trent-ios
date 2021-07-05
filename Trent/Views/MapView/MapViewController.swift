//
//  MapViewController.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 29.05.21.
//
import Foundation
import SwiftUI

class MapViewController: ObservableObject {
    static var shared = MapViewController()
    @Published var currentlyFocusedItem: Product?
}
