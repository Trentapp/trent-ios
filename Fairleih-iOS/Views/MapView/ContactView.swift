//
//  ContactView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 24.06.21.
//

import SwiftUI

struct ContactView: View {
    // @State var user: Profile
    @State var placeholder = "Message..."
    @State var message = ""
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        VStack {
            
            
            HStack {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity(0.5)
                    .foregroundColor(.gray)
                    .frame(width: 50, height: 50)
                    .padding()
                VStack(alignment: .leading, spacing: 4) {
                    Text("Max Mustermann")
                        .font(.system(size: 20, weight: .regular, design: .default))
                    HStack(alignment: .center, spacing: 2, content: {
                        //                        Text("5/5")
                        //                            .padding(.trailing, 5)
                        ForEach(Range(uncheckedBounds: (lower: 0, upper: 5))) { index in
                            Image(systemName: "star.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.yellow)
                                .frame(width: 20, height: 20)
                            //                                        .padding()
                            
                        }
                    })
                }
                
                Spacer()
            }
            Spacer()
                .frame(height: 50)
            Text("Message regarding Product: \"Tent\"")
            ZStack(alignment: .leading) {
                if(message.isEmpty) {
                    TextEditor(text: $placeholder)
                        .foregroundColor(.gray)
                        .opacity(0.5)
                }
                TextEditor(text: $message)
                    .border(Color.black, width: 0.2)
            }
            .frame(height: 200)
            .padding()
            
            HStack{
                Spacer()
                Button(action: {
                    print("Sending")
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 100, height:40)
                        Text("Send")
                            .bold()
                            .foregroundColor(.white)
                    }
                })
                .padding(.horizontal)
            }
            
            Spacer()
        }
        .navigationBarTitle("New Message", displayMode: .large)
    }
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView()
    }
}
