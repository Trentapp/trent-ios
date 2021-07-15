//
//  ContentView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 11.05.21.
//

import SwiftUI
import MapKit
//import Introspect

struct MapView: View {
    
    @State var keyword = ""
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 49.4, longitude: 8.675), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    @State var products: [Product] = []
    
    @State var showFilter = false
    
    @ObservedObject var backendClient = BackendClient.shared
    
//    @State var tabBar: UITabBar?
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
            Map(coordinateRegion: $region, annotationItems: products, annotationContent: { current_item in
                MapAnnotation(coordinate: current_item.location?.CLcoordinates ?? CLLocationCoordinate2D(latitude: 1000, longitude: 1000)) {
                    MapAnnotationButton(item: current_item)
                }
            })
            .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)})
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 0.25)
                    .foregroundColor(.gray)
                    .background(RoundedRectangle(cornerRadius: 5).fill(Color.white))
                    .frame(width: 350, height: showFilter ? 200 : 50, alignment: .center)
                    .shadow(radius: 5)
                    .animation(.easeInOut(duration: 0.3))
                    .overlay(
                        VStack {
                            HStack {
                                Spacer()
                                    .frame(width: 15)
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
                                .multilineTextAlignment(.leading)
                                //                            .frame(width: 250, height: 20, alignment: .center)
                                .padding(5)
                                Divider()
                                Spacer()
                                    .frame(width: 15)
                                Button(action: {
                                    self.showFilter.toggle()
                                }, label: {
                                    Image(systemName: "slider.horizontal.3")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 20, weight: showFilter ? .bold : .regular))
                                })
                                Spacer()
                                    .frame(width: 15)
                            }
                            .frame(width: 350, height: 50)
                            if(showFilter){
                                VStack {
                                    Divider()
                                    Spacer()
                                }
                            }
                        }
                    )
                Spacer()
                DetailBottomView()
            }
            
            
            
            
        })
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
//        .introspectTabBarController { (UITabBarController) in
//            self.tabBar = UITabBarController.tabBar
//        }
//        .onAppear() {
//            self.tabBar?.isHidden = false
//        }
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
