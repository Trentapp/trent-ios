//
//  AddProductView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 29.05.21.
//

import SwiftUI
import UIKit
import PhotosUI

struct AddProductView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var name = ""
    @State var description = ""
    @State var priceHour = ""
    @State var priceDay = ""
    
    @State var isAvailablePerHour = true
    @State var isAvailablePerDay = true
    
    @State var placeholder = "Description"
    
    @State var showAlert = false
    
    @State var isShowActionSheet = false
    @State var isShowPhotoLibrary = false
    @State var isShowCamera = false
    
    @State var photos: [UIImage] = []
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0, content: {
                Spacer()
                    .frame(height: 10)
                TextField("Name", text: $name)
                    .minimumScaleFactor(0.6)
                    .font(.largeTitle)
                    .padding(.horizontal, 20)
                    .padding(.vertical)
                ZStack(alignment: .leading) {
                    if(description.isEmpty) {
                        TextEditor(text: $placeholder)
                            .foregroundColor(.gray)
                            .opacity(0.5)
                    }
                    TextEditor(text: $description)
                }
                .padding(.horizontal, 15)
                .frame(height: 200)
                
                Divider()
                
                Text("Prices")
                    .padding()
                    .font(.system(size: 25, weight: .bold, design: .default))
                
                Toggle(isOn: $isAvailablePerHour, label: {
                    Text("Per hour")
                        .foregroundColor(isAvailablePerHour ? .black : .gray)
                    TextField("0", text: $priceHour)
                        .padding(.horizontal, 10)
                        .keyboardType(.numbersAndPunctuation)
                        .frame(width: 50)
                    Text("€")
                        .foregroundColor(isAvailablePerHour ? .black : .gray)
                })
                .padding(.horizontal)
                
                Toggle(isOn: $isAvailablePerDay, label: {
                    Text("Per day")
                        .foregroundColor(isAvailablePerDay ? .black : .gray)
                    TextField("0", text: $priceDay)
                        .padding(.horizontal, 10)
                        .keyboardType(.numbersAndPunctuation)
                        .frame(width: 50)
                    Text("€")
                        .foregroundColor(isAvailablePerDay ? .black : .gray)
                })
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                
                // Extremly ugly hack, plz fix @Apple
                PhotoView(isShowActionSheet: $isShowActionSheet, photos: $photos)
                
                
                Spacer()
                
                Button(action: {
                    
                    var prices: [String : Any] = [:]
                    
                    if let priceHourNumber = Double(priceHour) {
                        prices["perHour"] = priceHourNumber
                    }
                    
                    if let priceDayNumber = Double(priceDay) {
                        prices["perDay"] = priceDayNumber
                    }
                    
                    let address = (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(UserObjectManager.shared.user?.address))) as? [String: Any] ?? [:]
                    
                    
                    var photos_b64: [String] = []
                    
                    for photo in photos {
                        let photo_data = resizeImage(image: photo, targetSize: CGSize(width: 100, height: 100)).jpegData(compressionQuality: 0)
                        let photo_b64 = photo_data?.base64EncodedString() ?? ""
                        photos_b64.append(photo_b64)
                    }
                    
                    let parameters: [String : Any] = [
                        "name" : name,
                        "desc" : description,
                        "address" : address,
                        "prices" : prices,
                        "pictures" : photos_b64.first
                    ]
                    
                    let uid = AuthenticationManager.shared.currentUser?.uid ?? ""
                    
                    let request: [String : Any] = [
                        "uid" : uid,
                        "product" : parameters
                    ]
                    
                    BackendClient.shared.postNewItem(parameters: request) { successful in
                        print("successful: \(successful)")
                        if successful {
                            presentationMode.wrappedValue.dismiss()
                        } else {
                            showAlert = true
                        }
                    }

                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.blue)
                            .frame(height: 50)
                        Text("Publish")
                            .foregroundColor(.white)
                            .bold()
                    }
                })
                .padding(.all, 10)

            })
            
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text("An error occured when trying to add your item. Please try again later."), dismissButton: .default(Text("Cancel")))
            }
            
            .actionSheet(isPresented: $isShowActionSheet, content: {
                ActionSheet(title: Text("Select source of photo"), message: nil, buttons: [
                    Alert.Button.default(Text("Camera"), action: {
                        isShowCamera.toggle()
                    }),
                    Alert.Button.default(Text("Select from Library"), action: {
                        isShowPhotoLibrary.toggle()
                    }),
                    Alert.Button.cancel()
                ])
            })
        
            .sheet(isPresented: $isShowPhotoLibrary) {
                //ImagePicker(sourceType: .photoLibrary)
                PHPicker(selectedPhotos: $photos)
            }
            
            .fullScreenCover(isPresented: $isShowCamera) {
                ImagePicker(sourceType: .camera, selectedPhotos: $photos)
                    .ignoresSafeArea()
            }
            
            .navigationBarTitle("Add Product", displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel", action: {}))
        }
    }
}

struct PhotoView: View {
    @Binding var isShowActionSheet: Bool
    @Binding var photos: [UIImage]
    
    var body: some View {
        Divider()

        Text("Photos")
            .padding()
            .font(.system(size: 25, weight: .bold, design: .default))

        Button(action: {
            isShowActionSheet.toggle()
        }, label: {
            ZStack {
                Rectangle()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.blue)
                    .opacity(0.1)
                Image(systemName: "plus")
                    .font(.largeTitle.bold())
            }
        })
        .padding()
        
        Text("\(photos.count) image(s) selected")
                        
    }
}

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}


struct AddProductView_Previews: PreviewProvider {
    static var previews: some View {
        AddProductView()
    }
}