//
//  Launchscreen.swift
//  Trent
//
//  Created by Fynn Kiwitt on 06.07.21.
//

import SwiftUI

struct Launchscreen: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Text("hop on th trent.")
            .foregroundColor(colorScheme == .dark ? .white : .black)
    }
}
