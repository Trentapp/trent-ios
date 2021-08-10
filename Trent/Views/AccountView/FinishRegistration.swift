//
//  SwiftUIView.swift
//  Trent
//
//  Created by Fynn Kiwitt on 10.08.21.
//

import SwiftUI

struct FinishRegistration: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var birthday = Date()
    @State var nationality = "DE"
    @State var countryOfResidence = "DE"
    
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
                DatePicker("Date of birth" , selection: $birthday, displayedComponents: .date)
                Picker(selection: $nationality, label: Text("Nationality"), content: {
                    ForEach(self.countries, id: \.self) {
                        Text($0[1]).tag($0[0])
                    }
                })
                Picker(selection: $countryOfResidence, label: Text("Country of Residence"), content: {
                    ForEach(self.countries, id: \.self) {
                        Text($0[1]).tag($0[0])
                    }
                })
            }.navigationTitle("Finish registration")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel")
                .fontWeight(Font.Weight.regular)
            }))
        }
        Button {
            BackendClient.shared.createMangopayUser(birthday: Int(birthday.timeIntervalSince1970), nationality: nationality, countryOfResidence: countryOfResidence) { success in
                if !success {
                    // tell user
                }
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(.blue)
                Text("Finish registration")
                    .bold()
                    .foregroundColor(.white)
            }
            .frame(height: 50)
            .padding()
        }

    }
}

struct FinishRegistration_Previews: PreviewProvider {
    static var previews: some View {
        FinishRegistration()
    }
}
