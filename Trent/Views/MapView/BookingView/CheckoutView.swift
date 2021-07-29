//
//  CheckoutView.swift
//  Trent
//
//  Created by Fynn Kiwitt on 29.07.21.
//

import SwiftUI

struct CheckoutView: View {
    
    @ObservedObject var model: BookingModelView
    
    @State var expirationMonth = ""
    @State var expirationYear = ""
    
    @State var showDatePicker = false
    @State var showCardScanner = false
    
    var body: some View {
            VStack {
                Spacer()
                    .frame(height: 25)
                Group {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 0.2)
                            .foregroundColor(.init(.displayP3, white: 0.4, opacity: 0.5))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 0)
                        TextField("Name", text: $model.creditCardHolder)
                            .textContentType(.name)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                    }
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 0.2)
                            .foregroundColor(.init(.displayP3, white: 0.4, opacity: 0.5))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 0)
                        TextField("Card number", text: $model.creditCardNumber)
                            .textContentType(.creditCardNumber)
                            .keyboardType(.numberPad)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                    }
                    HStack {
                        Text("Expiration Date")
                            .padding(.leading, 30)
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                Text("")
                            }
                        })
                        Spacer()
                            .frame(width: 55)
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 0.2)
                                .foregroundColor(.init(.displayP3, white: 0.4, opacity: 0.5))
                                .padding(.trailing, 20)
                                .padding(.vertical, 0)
                            TextField("CCV", text: $model.ccv)
                                .keyboardType(.numberPad)
                                .padding(.leading, 30)
                                .padding(.trailing, 10)
                        }
                        .frame(width: 100)
                        
                        
                    }
                }
                .frame(height: 40)
                
                
                Spacer()
                Divider()
                    .border(Color.black, width: 10)
                HStack{
                    VStack(alignment: .center, spacing: nil, content: {
                        Text("\(String(format:"%.02f", (round((model.transaction?.totalPrice ?? 0)*100)/100)))€")
                            .font(.system(size: 25))
                            .bold()
                        Text("Total Price")
                            .font(.system(size: 15))
                            .foregroundColor(.gray)
                    })
                    .padding(.horizontal, 15)

                    Spacer()
                    Button(action: {
                        //
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 100, height:40)
                            Text("Pay")
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
            .sheet(isPresented: $showCardScanner, content: { CreditCardScannerView(model: model) })
            .onAppear() {
                showCardScanner = true
            }
    }
}


//struct CheckoutView_Previews: PreviewProvider {
//    static var previews: some View {
//        CheckoutView()
//    }
//}
