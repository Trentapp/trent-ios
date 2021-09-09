//
//  CheckoutView.swift
//  Trent
//
//  Created by Fynn Kiwitt on 29.07.21.
//

import SwiftUI

struct PaymentView: View {
    @ObservedObject var model: PaymentViewModel
    @ObservedObject var mainViewProperties = MainViewProperties.shared
    
    @State private var selectedCard = ""
    @State var cards: [Card]?
    
    var body: some View {
        VStack {
            
            Form {
                Section(header: Text("Select credit card")) {
                    ForEach(cards ?? [], id: \.Id) { card in
                        Button {
                            selectedCard = card.Id
                        } label: {
                            HStack {
                                Group {
                                    let cardNumberPrefix = card.Alias.prefix(1)
                                    
                                    if cardNumberPrefix == "4" {            // Visa
                                        Image("visa_symbol")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    } else if cardNumberPrefix == "" {      // MasterCard
                                        Image("mc_symbol")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    } else {
                                        Spacer()
                                    }
                                }
                                .frame(width: 35)
                                Group{
                                    VStack {
                                        HStack {
                                            Text("\(card.Alias)")
                                                .foregroundColor(Color(UIColor.label))
                                            Spacer()
                                        }
                                        HStack {
                                            Text("\(card.expirationDateHR)")
                                                .foregroundColor(.gray)
                                                .font(.system(size: 15))
                                            Spacer()
                                        }
                                    }
                                    if selectedCard == card.Id {
                                        Spacer()
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                            }
                        }
                    }
                    Button(action: {}, label: {
                        Text("Add a new card")
                    })
                }
            }
            
            Spacer()
            Divider()
                .border(Color.black, width: 10)
            HStack{
                VStack(alignment: .center, spacing: nil, content: {
                    Text("\(String(format:"%.02f", (round(model.totalPrice * 100)/100)))€")
                        .font(.system(size: 25))
                        .bold()
                    Text("Total Price")
                        .font(.system(size: 15))
                        .foregroundColor(.gray)
                })
                .padding(.horizontal, 15)
                
                Spacer()
                Button(action: {
                    BackendClient.shared.createCard(cardNumber: model.creditCardNumber, expirationDate: model.expirationDate, cvx: model.cvx) { success in
                        if success {
                            // do smth
                        } else {
                            // tell user
                        }
                    }
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 100, height:40)
                        Text("Pay Now")
                            .bold()
                            .foregroundColor(.white)
                    }
                })
                .padding(.horizontal, 15)
            }
            .padding(.bottom, 0)
        }
        .navigationBarTitle("Payment", displayMode: .large)
        .navigationBarHidden(false)
        .onAppear() {
            // load cards
            BackendClient.shared.getCards { cards in
                self.cards = cards
            }
        }
    }
}


//struct CheckoutView_Previews: PreviewProvider {
//    static var previews: some View {
//        PaymentView(model: BookingModelView(item: Product(_id: "")))
//            
//    }
//}
