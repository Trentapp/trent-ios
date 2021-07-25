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
        self.displayedAnnotationItems = self.annotationItems
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.userTrackingMode = userTrackingMode
        uiView.region = region
        
        if displayedAnnotationItems != annotationItems {
            let annotations = getAnnotations()
            uiView.removeAnnotations(uiView.annotations)
            uiView.addAnnotations(annotations)
            
            self.displayedAnnotationItems = self.annotationItems
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
            let buttonView = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 25))
            buttonView.layer.cornerRadius = 12.5
            buttonView.layer.masksToBounds = true
            
            if let annotationItem = annotation as? ProductAnnotation {
                let item = annotationItem.item
                buttonView.setTitle("\(Int(item.prices?.perDay ?? 0))€", for: .normal)
                buttonView.setTitleColor(UIColor.black, for: .normal)
                buttonView.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
                
                if item == MapViewController.shared.currentlyFocusedItem {
                    buttonView.backgroundColor = .black
                    buttonView.setTitleColor(UIColor.black, for: .normal)
                } else {
                    buttonView.backgroundColor = .white
                }
            }
            
            let identifier = "Placemark"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.addSubview(buttonView)
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }

//        func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
//            <#code#>
//        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let productAnnotation = view.annotation as? ProductAnnotation {
                MapViewController.shared.currentlyFocusedItem = productAnnotation.item
            }
        }
        
//        func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
//            if let productAnnotation = view.annotation as? ProductAnnotation {
//                if productAnnotation.item == MapViewController.shared.currentlyFocusedItem {
//                    MapViewController.shared.currentlyFocusedItem = nil
//                }
//            }
//        }
    }
}


class ProductAnnotation: NSObject, MKAnnotation {
    var item: Product
    var coordinate: CLLocationCoordinate2D {
        get {
            return item.location?.CLcoordinates ?? CLLocationCoordinate2D(latitude: 1000, longitude: 1000)
        }
    }
    
    init(item: Product) {
        self.item = item
    }
}
