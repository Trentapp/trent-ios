//
//  ContactView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 24.06.21.
//

import SwiftUI

struct ContactView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var user: UserProfile?
    var product: Product?
    @State var placeholder = "Message..."
    @State var message = ""
    
    var body: some View {
        VStack {
            
            
            HStack {
                ((user?.pictureUIImage != nil) ? Image(uiImage: (user?.pictureUIImage!)!) : Image(systemName: "person.crop.circle"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity((user?.pictureUIImage != nil) ? 1 : 0.5)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
                    .frame(width: 50, height: 50)
                    .padding()
                VStack(alignment: .leading, spacing: 4) {
                    Text(user?.name ?? "User")
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
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 0.3)
                    .foregroundColor(.gray)
                if(message.isEmpty) {
                    TextEditor(text: $placeholder)
                        .foregroundColor(.gray)
                        .opacity(0.5)
                }
                TextEditor(text: $message)
            }
            .frame(height: 200)
            .padding()
            
            HStack{
                Spacer()
                Button(action: {
                    BackendClient.shared.sendMessage(product_id: product?._id ?? "", content: message) { success in
                        if !success {
                            // tell user
                        } else {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
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
        .onAppear() {
            UITextView.appearance().backgroundColor = .clear
        }
    }
}

//struct ContactView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContactView()
//    }
//}
