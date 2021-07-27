//
//  MapKitView.swift
//  Trent
//
//  Created by Fynn Kiwitt on 24.07.21.
//

import SwiftUI
import MapKit

struct MapKitView: UIViewRepresentable {
    @Binding var userTrackingMode: MKUserTrackingMode
    @Binding var region: MKCoordinateRegion
    @Binding var annotationItems: [Product]
    @Binding var displayedAnnotationItems: [Product]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.region = region
        mapView.userTrackingMode = MKUserTrackingMode.follow
        mapView.isRotateEnabled = false
        mapView.delegate = context.coordinator
        
        let annotations = getAnnotations()
        mapView.addAnnotations(annotations)
        //        self.displayedAnnotationItems = self.annotationItems
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.userTrackingMode = userTrackingMode
        uiView.region = region
        
        if displayedAnnotationItems != annotationItems {
            let annotations = getAnnotations()
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(annotations)
            
            //            self.displayedAnnotationItems = self.annotationItems
        }
    }
    
    func getAnnotations() -> [MKAnnotation] {
        var annotations = [MKAnnotation]()
        for item in annotationItems {
            let annotation = ProductAnnotation(item: item)
            annotations.append(annotation)
        }
        return annotations
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var mapKitView: MapKitView
        
        init(_ mapKitView: MapKitView){
            self.mapKitView = mapKitView
        }
        
        func updateMapKitView(sender: MKMapView) {
            mapKitView.region = sender.region
            mapKitView.userTrackingMode = sender.userTrackingMode
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            updateMapKitView(sender: mapView)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // TODO: dequeue
            if annotation.isEqual(mapView.userLocation) {
                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "userLocation")
                annotationView.image = UIImage(named: "geo")
                return annotationView
            }
            
            let buttonView = AnnotationButton(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
            buttonView.layer.cornerRadius = 12.5
            buttonView.layer.masksToBounds = true
            buttonView.isUserInteractionEnabled = false
            
            if let annotationItem = annotation as? ProductAnnotation {
                let item = annotationItem.item
                buttonView.item = item
                buttonView.setTitle("\(Int(item.prices?.perDay ?? 0))€", for: .normal)
                buttonView.setTitleColor(UIColor.black, for: .normal)
                buttonView.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
                
                if item == MapViewController.shared.currentlyFocusedItem {
                    buttonView.backgroundColor = .black
                    buttonView.setTitleColor(.white, for: .normal)
                } else {
                    buttonView.backgroundColor = .white
                    buttonView.setTitleColor(.black, for: .normal)
                }
            }
            
            let identifier = "Placemark"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? ProductAnnotationView
            
            if annotationView == nil {
                annotationView = ProductAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = annotation
                annotationView?.priceTag?.removeFromSuperview()
            }
            
//            if annotationView!.isSelected {
//                buttonView.backgroundColor = .black
//                buttonView.setTitleColor(.white, for: .normal)
//            } else {
//                buttonView.backgroundColor = .white
//            }
            
            annotationView?.priceTag = buttonView
            
            annotationView?.frame.size.width = 50
            annotationView?.frame.size.height = 25
            annotationView?.addSubview((annotationView?.priceTag)!)
            
            return annotationView
        }
        
        @objc func annotationPressed(_ sender: AnnotationButton){
            MapViewController.shared.currentlyFocusedItem = sender.item
        }
        
        //        func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        //            <#code#>
        //        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let productAnnotation = view.annotation as? ProductAnnotation {
                MapViewController.shared.currentlyFocusedItem = productAnnotation.item
            }
            
            if let annotationButton = view as? ProductAnnotationView {
                annotationButton.priceTag?.backgroundColor = .black
                annotationButton.priceTag?.setTitleColor(.white, for: .normal)
            }
        }
        
        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
            if let annotationButton = view as? ProductAnnotationView {
                annotationButton.priceTag?.backgroundColor = .white
                annotationButton.priceTag?.setTitleColor(.black, for: .normal)
            }

        }
    }
}

class ProductAnnotationView: MKAnnotationView {
    var priceTag: AnnotationButton?
}

class AnnotationButton: UIButton {
    var item: Product?
}

class ProductAnnotation: NSObject, MKAnnotation {
    var item: Product
    var coordinate: CLLocationCoordinate2D {
        get {
            return item.location?.CLcoordinates ?? CLLocationCoordinate2D(latitude: 1000, longitude: 1000)
        }
    }
    
    var title: String? {
        get {
            return "\(Int(item.prices?.perDay ?? 0))€"
        }
    }
    
    init(item: Product) {
        self.item = item
    }
}
