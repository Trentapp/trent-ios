//
//  BookingOverviewView.swift
//  Trent
//
//  Created by Fynn Kiwitt on 30.07.21.
//

import SwiftUI

struct BookingOverviewView: View {
    
    var model: BookingModelView
    
    @State var startDateString = ""
    @State var endDateString = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(model.item.name ?? "Item")
                .font(.system(size: 24))
                .bold()
                .padding([.horizontal, .top])
            Text("\(startDateString) - \(endDateString)")
                .padding(.horizontal)
            Spacer()
            Button {
                //
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.blue)
                    Text("Book now")
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(height: 45)
                .padding()
            }

        }
        .navigationBarTitle("Overview", displayMode: .large)
        .onAppear() {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm E, d MMM y"
            startDateString = formatter.string(from: model.startDate)
            startDateString = formatter.string(from: model.endDate)
        }
    }
}

struct BookingOverviewView_Previews: PreviewProvider {
    static var previews: some View {
        BookingOverviewView(model: BookingModelView(item: Product(_id: "")))
    }
}
