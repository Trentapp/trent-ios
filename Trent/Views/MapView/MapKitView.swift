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
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.region = region
        mapView.userTrackingMode = MKUserTrackingMode.follow
        mapView.isRotateEnabled = false
        mapView.delegate = context.coordinator
        
        let annotations = getAnnotations()
        mapView.addAnnotations(annotations)
        
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.userTrackingMode = userTrackingMode
        uiView.region = region
        
        let annotations = getAnnotations()
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)
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
        
//        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//            MKAnnotationView(annotation: <#T##MKAnnotation?#>, reuseIdentifier: <#T##String?#>)
//        }
//
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
