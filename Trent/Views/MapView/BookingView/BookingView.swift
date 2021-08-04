//
//  BookingView.swift
//  Trent
//
//  Created by Fynn Kiwitt on 28.07.21.
//

import SwiftUI

struct BookingView: View {
    
    @ObservedObject var model: BookingModelView
    
    @State var message = ""
    
    @State var showPayment = false
    
    func updatePrice() {
        model.totalPrice = (model.item.prices?.perDay ?? 0) * Double(model.duration)
    }
    
    var body: some View {
        //        NavigationView {
        VStack {
            HStack {
                Text("When do you want to rent this item?")
                    .bold()
                    .padding()
                Spacer()
            }
            DatePicker("Start date", selection: $model.startDate)
                .padding(.horizontal)
            DatePicker("End date", selection: $model.endDate)
                .padding(.horizontal)
                .padding(.bottom, 30)
            
            HStack {
                Text("Optional Message to the lender")
                    .bold()
                Spacer()
            }
            .padding(.leading)
            
            ZStack(alignment: .leading) {
                if(message.isEmpty) {
                    TextEditor(text: .constant("Message to \(model.item.user?.name ?? "the lender")"))
                        .foregroundColor(.gray)
                        .opacity(0.5)
                }
                TextEditor(text: $message)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 0.2)
            }
            .padding(.horizontal, 15)
            .frame(height: 200)
            NavigationLink(
                "", destination:PaymentView(model: model),
                isActive: $showPayment).hidden(true)
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
                    //                        BackendClient
                    showPayment = true
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 100, height:40)
                        Text("Confirm")
                            .bold()
                            .foregroundColor(.white)
                    }
                })
                .padding(.horizontal, 15)
            }
            .padding(.bottom, 0)
        }
        .navigationBarTitle("Booking details", displayMode: .large)
        .navigationBarHidden(false)
        //        }
        .onAppear() {
            model.startDate = Date(timeIntervalSinceNow: 86400)
            model.endDate = Date(timeIntervalSinceNow: 172800)
            updatePrice()
        }
        .onChange(of: model.startDate, perform: { value in
            updatePrice()
        })
        .onChange(of: model.endDate, perform: { value in
            updatePrice()
        })
        .onChange(of: MainViewProperties.shared.popToRootView , perform: { value in
            if value {
                showPayment = false
                MainViewProperties.shared.popToRootView = false
            }
        })
    }
}

struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        BookingView(model: BookingModelView(item: Product(_id:"")))
    }
}
