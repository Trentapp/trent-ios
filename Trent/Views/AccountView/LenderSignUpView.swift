//
//  LenderSignUpView.swift
//  Trent
//
//  Created by Fynn Kiwitt on 10.08.21.
//

import SwiftUI

struct LenderSignUpView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var streetWithNr = UserObjectManager.shared.user?.address?.streetWithNr ?? ""
    @State var zipcode = UserObjectManager.shared.user?.address?.zipcode ?? ""
    @State var city = UserObjectManager.shared.user?.address?.city ?? ""
    @State var country = UserObjectManager.shared.user?.address?.country ?? ""
    
    @State var iban = ""
    
    @State var kycDocumentFront: UIImage?
    @State var kycDocumentBack: UIImage?
    
    @State var shootFrontPicture = false
    @State var shootBackPicture = false
    
    @State var isLoading = false
    
    var countries : [[String]] {
        get {
            var _countries = [[String]]()
            
            for code in NSLocale.isoCountryCodes {
                let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
                let name = NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "\(code)"
                _countries.append(["\(code)", "\(name)"])
            }
            _countries.sort { a, b in return a[1] < b[1] }
            return _countries
        }
    }
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Address")) {
                    TextField("Street", text: $streetWithNr)
                        .textContentType(.streetAddressLine1)
                    TextField("Zipcode", text: $zipcode)
                        .textContentType(.postalCode)
                    TextField("City", text: $city)
                        .textContentType(.addressCity)
                    TextField("Country", text: $country)
                        .textContentType(.countryName)
                }
                
                Section(header: Text("Bank account")) {
                    TextField("IBAN", text: $iban)
                }
                
                Section(header: Text("ID card")) {
                    Button {
                        shootFrontPicture = true
                    } label: {
                        HStack {
                            Text("Front image")
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                                .hidden(kycDocumentFront == nil)
                        }
                    }
                    
                    Button {
                        shootBackPicture = true
                    } label: {
                        HStack {
                            Text("Back image")
                            Image(systemName: "checkmark")
                                .foregroundColor(.green)
                                .hidden(kycDocumentBack == nil)
                        }
                    }

                }
            }
            .fullScreenCover(isPresented: $shootFrontPicture) {
                SingleImagePicker(sourceType: .camera, onImagePicked: { image in
                    self.kycDocumentFront = image
                })
                    .ignoresSafeArea()
            }
            
            .fullScreenCover(isPresented: $shootBackPicture) {
                SingleImagePicker(sourceType: .camera, onImagePicked: { image in
                    self.kycDocumentBack = image
                })
                    .ignoresSafeArea()
            }
            
            .navigationTitle("Become a lender")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel")
                .fontWeight(Font.Weight.regular)
            }), trailing: ProgressView().progressViewStyle(CircularProgressViewStyle()).hidden(!isLoading))
        }
        Button {
            isLoading = true
//            BackendClient.shared.createMangopayUser(birthday: Int(birthday.timeIntervalSince1970), nationality: nationality, countryOfResidence: countryOfResidence) { success in
//                if !success {
//                    // tell user
//                } else {
//                    MainViewProperties.shared.showInfo(with: "Data submitted")
//                    self.presentationMode.wrappedValue.dismiss()
//                }
//            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.blue)
                Text("Become a lender")
                    .bold()
                    .foregroundColor(.white)
            }
            .frame(height: 50)
            .padding()
        }.disabled(isLoading)

    }
}

struct LenderSignUpView_Previews: PreviewProvider {
    static var previews: some View {
        LenderSignUpView()
    }
}
