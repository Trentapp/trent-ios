//
//  ContentView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 11.05.21.
//

import SwiftUI
import MapKit
import Introspect

struct MapView: View {
    
    @State var keyword = ""
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 49.4, longitude: 8.675), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @State var products: [Product] = []
    
    @ObservedObject var backendClient = BackendClient.shared
    
    @State var tabBar: UITabBar?
    
    var body: some View {
        NavigationView {
            ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                Map(coordinateRegion: $region, annotationItems: products, annotationContent: { current_item in
                    MapAnnotation(coordinate: current_item.location?.CLcoordinates ?? CLLocationCoordinate2D(latitude: 1000, longitude: 1000)) {
                        MapAnnotationButton(item: current_item)
                    }
                })
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(lineWidth: 1)
                        .foregroundColor(.black)
                        .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                        .frame(width: 250, height: 33, alignment: .center)
                        .overlay(
                            TextField("\(Image(systemName: "magnifyingglass")) What are you looking for?", text: $keyword, onEditingChanged: { editing in
                                print("editing: \(editing)")
                            }, onCommit: {
                                UIApplication.shared.endEditing()
                                print("Did commit: \(keyword)")
                                DispatchQueue.global().async {
                                    self.products = backendClient.query(keyword: keyword)
                                }
                            })
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .multilineTextAlignment(.center)
                                .frame(width: 250, height: 20, alignment: .center)
                                .padding(5)
                        )
                    
                    Spacer()
                    DetailBottomView()
                }
                
                
                
                    
            })
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .introspectTabBarController { (UITabBarController) in
                self.tabBar = UITabBarController.tabBar
            }
            .onAppear() {
                self.tabBar?.isHidden = false
            }
        }
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
