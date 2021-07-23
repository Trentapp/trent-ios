//
//  AccountView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 29.05.21.
//

import SwiftUI

struct AccountView: View {
    
    @ObservedObject var userObjectManager = UserObjectManager.shared
    @State var isShownLogOutAlert = false
    @State var isShownActionSheet = false
    @State var isShownCamera = false
    @State var isShownPhotoLibrary = false
    @State var newPicture: Image?
    //    @State var image = UIImage(systemName: "person.crop.circle")!
    
    func rotateImage(image: UIImage) -> UIImage? {
        if (image.imageOrientation == UIImage.Orientation.up ) {
            return image
        }
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return copy
    }
    
    var body: some View {
        VStack {
            Button(action:{
                isShownActionSheet.toggle()
            }, label: {
                ((userObjectManager.user?.pictureUIImage != nil) ? Image(uiImage: (userObjectManager.user?.pictureUIImage!)!) : Image(systemName: "person.crop.circle"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .opacity((userObjectManager.user?.pictureUIImage != nil) ? 1 : 0.5)
                    .foregroundColor(.gray)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            })
            Text(userObjectManager.user?.name ?? "")
                .font(.largeTitle)
                .bold()
            List{
                Section {
                    ZStack{
                        Button(""){}
                        NavigationLink("Edit Profile", destination: EditAccountView())
                    }
                }
                Section {
                    HStack{
                        Spacer()
                        Button(action: {
                            self.isShownLogOutAlert.toggle()
                        }, label: {
                            Text("Log out")
                                .foregroundColor(.red)
                        })
                        Spacer()
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .onAppear {
                UITableView.appearance().isScrollEnabled = false
            }
            .alert(isPresented: $isShownLogOutAlert, content: {
                Alert(title: Text("Log out"), message: Text("Are you sure you want to log out of your current account? You will need to log back in with your password to gain access to your account again on this device."), primaryButton: .cancel(), secondaryButton: .destructive(Text("Log out"), action: {
                    userObjectManager.logOut { success in
                        if success {
                            MainViewProperties.shared.selectedItem = tabBarConfigurations[0]
                        }
                    }
                    
                }))
            })
        }
        .actionSheet(isPresented: $isShownActionSheet, content: {
            ActionSheet(title: Text("Select source of photo"), message: nil, buttons: [
                Alert.Button.default(Text("Camera"), action: {
                    isShownCamera.toggle()
                }),
                Alert.Button.default(Text("Select from Library"), action: {
                    isShownPhotoLibrary.toggle()
                }),
                Alert.Button.destructive(Text("Delete profile picture"), action: {
                    BackendClient.shared.deleteProfilePicture() { success in
                        if !success {
                            // Tell the user
                        }
                    }
                }),
                Alert.Button.cancel()
            ])
        })
        
        .sheet(isPresented: $isShownPhotoLibrary) {
            SingleImagePicker(sourceType: .photoLibrary) { image in
                BackendClient.shared.uploadNewProfilePicture(photo: image) { success in
                    //
                }
            }
        }
        
        .fullScreenCover(isPresented: $isShownCamera) {
            SingleImagePicker(sourceType: .camera) { image in
                let correctedImage = rotateImage(image: image) ?? UIImage()
                BackendClient.shared.uploadNewProfilePicture(photo: correctedImage) { success in
                    //
                }
            }
            .ignoresSafeArea()
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        //                        .navigationBarTitle("Account")
        //                        .navigationBarHidden(false)
        .navigationViewStyle(DefaultNavigationViewStyle())
    }
    
}

public struct SingleImagePicker: UIViewControllerRepresentable {
    
    private let sourceType: UIImagePickerController.SourceType
    private let onImagePicked: (UIImage) -> Void
    @Environment(\.presentationMode) private var presentationMode
    
    public init(sourceType: UIImagePickerController.SourceType, onImagePicked: @escaping (UIImage) -> Void) {
        self.sourceType = sourceType
        self.onImagePicked = onImagePicked
    }
    
    public func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = self.sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    public func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(
            onDismiss: { self.presentationMode.wrappedValue.dismiss() },
            onImagePicked: self.onImagePicked
        )
    }
    
    final public class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        private let onDismiss: () -> Void
        private let onImagePicked: (UIImage) -> Void
        
        init(onDismiss: @escaping () -> Void, onImagePicked: @escaping (UIImage) -> Void) {
            self.onDismiss = onDismiss
            self.onImagePicked = onImagePicked
        }
        
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                self.onImagePicked(image)
            }
            self.onDismiss()
        }
        
        public func imagePickerControllerDidCancel(_: UIImagePickerController) {
            self.onDismiss()
        }
        
    }
    
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
    }
}
