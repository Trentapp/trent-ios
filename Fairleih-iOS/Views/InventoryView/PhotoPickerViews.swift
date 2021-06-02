//
//  PhotoPickerViews.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 02.06.21.
//

import SwiftUI
import UIKit
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
 
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedPhotos: [UIImage]
 
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
 
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
 
        return imagePicker
    }
 
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
 
    }
    
    func makeCoordinator() -> ImagePickerDelegate {
        ImagePickerDelegate(self)
    }
}

class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate {
    
    private var parent: ImagePicker
    
    init(_ parent: ImagePicker){
        self.parent = parent
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            parent.selectedPhotos.append(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("")
    }
    
}

struct PHPicker: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var isPresented
    @Binding var selectedPhotos: [UIImage]
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = PHPickerFilter.images
        configuration.selectionLimit = 0

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> PHPickerDelegate {
        PHPickerDelegate(self)
    }
        
}

class PHPickerDelegate: PHPickerViewControllerDelegate {
    
    private var parent: PHPicker
    
    init(_ parent: PHPicker){
        self.parent = parent
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        parent.isPresented.wrappedValue.dismiss()
        
        for result in results {
              result.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (object, error) in
                 if let image = object as? UIImage {
                    DispatchQueue.main.async {
                       // Use UIImage
                        self.parent.selectedPhotos.append(image)
                    }
                 }
              })
           }
    }
    
    
}
