//
//  CheckoutView.swift
//  Trent
//
//  Created by Fynn Kiwitt on 29.07.21.
//

import SwiftUI

struct PaymentView: View {
    
    @ObservedObject var model: BookingModelView
    @ObservedObject var mainViewProperties = MainViewProperties.shared
    
    @State var showOverview = false
    
    @State var showDatePicker = false
    @State var showCardScanner = false
    @State var showExiprationPicker = false
    
    @State var minimumMonth = 0
    @State var minimumYear = 0
    
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
//                        Text("Expiration Date")
//                            .padding(.leading, 30)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 0.2)
                                .foregroundColor(.init(.displayP3, white: 0.4, opacity: 0.5))
                                .padding(.leading, 20)
                                .padding(.vertical, 0)
                            TextField("CVV", text: $model.cvv)
                                .keyboardType(.numberPad)
                                .padding(.leading, 30)
                                .padding(.trailing, 10)
                        }
                        .frame(width: 100)
                        
                        Spacer()
//                            .frame(width: 55)
                        
                        Button(action: {
                            showExiprationPicker.toggle()
                        }, label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundColor(Color( self.showExiprationPicker ? UIColor.systemFill : UIColor.systemGroupedBackground ))
                                Text("\(String(format:"%02d", model.expirationMonth))/\(String(format:"%02d", model.expirationYear))")
                                    .foregroundColor(.blue)
                            }
                            .frame(width: 150)
                        })
                        .padding(.trailing, 20)
                    }
                }
                .frame(height: 40)
                
                if showExiprationPicker {
                    HStack {
                        Spacer()
                        Picker(selection: $model.expirationMonth, label: Text("Picker"), content: {
                            ForEach(1..<13, id: \.self) { index in
                                Text("\(String(format: "%02d",index))").tag(index)
                            }
                        })
                        .animation(.easeInOut(duration: 0.2))
                        .labelsHidden()
                        .frame(width: 200)
                        .clipped()
                        Spacer()
                        Picker(selection: $model.expirationYear, label: Text("Picker"), content: {
                            ForEach((minimumYear)..<(minimumYear + 20), id: \.self) { index in
                                Text(String(index)).tag(index)
                            }
                        })
                        .animation(.easeInOut(duration: 0.2))
                        .labelsHidden()
                        .frame(width: 200)
                        .clipped()
                        Spacer()
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
                        showOverview = true
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 100, height:40)
                            Text("Next")
                                .bold()
                                .foregroundColor(.white)
                        }
                    })
                    .padding(.horizontal, 15)
                }
                .padding(.bottom, 0)
                NavigationLink(
                    destination: BookingOverviewView(model: model),
                    isActive: $showOverview,
                    label: {
                        EmptyView()
                    })
            }
            .navigationBarTitle("Payment", displayMode: .large)
            .navigationBarHidden(false)
            .sheet(isPresented: $showCardScanner, content: { CreditCardScannerView(model: model) })
            .onChange(of: model.expirationMonth, perform: { value in
                if model.expirationYear == minimumYear && value < minimumMonth{
                    model.expirationMonth = minimumMonth
                }
            })
            .onChange(of: model.expirationYear, perform: { value in
                if value == minimumYear && model.expirationMonth < minimumMonth{
                    model.expirationMonth = minimumMonth
                }
            })
            .onAppear() {
                showCardScanner = true
                
                let date = Date()
                let components = Calendar.current.dateComponents(in: Calendar.current.timeZone, from: date)
                let currentMonth = components.month ?? 0
                let currentYear = components.year ?? 0
                
                model.expirationMonth = currentMonth
                model.expirationYear = currentYear
                
                minimumMonth = currentMonth
                minimumYear = currentYear
            }
            .onChange(of: mainViewProperties.popToRootView, perform: { value in
                if value {
                    showOverview = false
                }
            })
    }
}


struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView(model: BookingModelView(item: Product(_id: "")))
            
    }
}
