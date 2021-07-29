//
//  BookingView.swift
//  Trent
//
//  Created by Fynn Kiwitt on 28.07.21.
//

import SwiftUI

struct BookingView: View {
    var item: Product?
    @State var transaction: Transaction?
    @State var startDate = Date(timeIntervalSinceNow: 86400)
    @State var endDate = Date(timeIntervalSinceNow: 172800)
    
    @State var totalPrice: Double = 0
    
    @State var message = ""
    
    @State var showPayment = false
    
    func updatePrice() {
        let duration = (startDate.distance(to: endDate)) / (86400)
        totalPrice = max((item?.prices?.perDay ?? 0) * ceil(duration), 0)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("When do you want to rent this item?")
                        .bold()
                        .padding()
                    Spacer()
                }
                DatePicker("Start date", selection: $startDate)
                    .padding(.horizontal)
                DatePicker("End date", selection: $endDate)
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
                        TextEditor(text: .constant("Message to \(item?.user?.name ?? "the lender")"))
                            .foregroundColor(.gray)
                            .opacity(0.5)
                    }
                    TextEditor(text: $message)
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 0.2)
                }
                .padding(.horizontal, 15)
                .frame(height: 200)
                
                Spacer()
                Divider()
                    .border(Color.black, width: 10)
                HStack{
                    VStack(alignment: .center, spacing: nil, content: {
                        Text("\(String(format:"%.02f", (round(totalPrice*100)/100)))€")
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
                            Text("Checkout")
                                .bold()
                                .foregroundColor(.white)
                        }
                    })
                    .padding(.horizontal, 15)
                }
                .padding(.bottom, 0)
                NavigationLink(
                    "", destination: CheckoutView(item: item, transaction: transaction),
                    isActive: $showPayment).hidden(true)
            }
            .navigationBarTitle("Booking details", displayMode: .large)
            .navigationBarHidden(false)
        }
        .onAppear() {
            updatePrice()
        }
        .onChange(of: startDate, perform: { value in
            updatePrice()
        })
        .onChange(of: endDate, perform: { value in
            updatePrice()
        })
    }
}

struct BookingView_Previews: PreviewProvider {
    static var previews: some View {
        BookingView()
    }
}
