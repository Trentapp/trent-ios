//
//  CreditCardScannerVIew.swift
//  Trent
//
//  Created by Fynn Kiwitt on 29.07.21.
//

import SwiftUI
import SweetCardScanner

struct CreditCardScannerView: View {
    
    @ObservedObject var model: BookingModelView
    
    @Environment(\.presentationMode) var presentationMode
    @State var card: CreditCard?
    
    var body: some View {
        NavigationView {
        GeometryReader { geometry in
            ZStack {
                if true /*navigationStatus == .ready*/ {
                    /*
                     You can add some words "in lowercase" to try to skip in recognition to improve the performance like bank names,
                     such as "td", "td banks", "cibc", and so on.
                     Also you can try to add some words "in lowercase" for invalid names, such as "thru", "authorized", "signature".
                     Or you can just simply usw liek "SweetCardScanner()"
                     */
                    SweetCardScanner(
                        wordsToSkip: ["td", "td bank", "cibc", "world", "N26", "debit"],
                        invalidNames: ["thru", "authorized", "signature"]
                    )
                    .onError { err in
                        presentationMode.wrappedValue.dismiss()
                    }
                    .onSuccess { card in
                        self.card = card
                        print(card)
                        
                        if !(card.isNotExpired ?? true) {
                            
                            return
                        }
                        
                        model.creditCardHolder = card.name ?? ""
                        model.creditCardNumber = card.number ?? ""
                        
                        presentationMode.wrappedValue.dismiss()
//                        self.navigationStatus = .pop
                    }
                }
                
                RoundedRectangle(cornerRadius: 16)
                    .stroke()
                    .foregroundColor(.white)
                    .padding(16)
                    .frame(width: geometry.size.width, height: geometry.size.width * 0.63, alignment: .center)
                
            }
        }
        .alert(isPresented: .constant(false), content: {
            Alert(title: Text("Card expired"), message: Text("Please use another card."), dismissButton: .default(Text("Okay")))
        })
        .navigationBarTitle("Scan Credit Card", displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Cancel")
                .fontWeight(Font.Weight.regular)
        }))
        }
    }
}
