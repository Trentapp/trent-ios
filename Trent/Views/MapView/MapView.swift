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
    
    @State var showFilter = false {
        willSet {
            if suppressAnimation {
                suppressAnimation = false
            }
        }
    }
    @State var suppressAnimation = true
    
    @ObservedObject var backendClient = BackendClient.shared
    
    //    @State var tabBar: UITabBar?
    
    // Filter
    @State var minPriceValue: CGFloat = 0
    @State var maxPriceValue: CGFloat = 1
    @State var maxPrice = 100.0
    
    @State var maxDistanceValue: CGFloat = 0.5
    var maxDistance = 25
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
            Map(coordinateRegion: $region, annotationItems: products, annotationContent: { current_item in
                MapAnnotation(coordinate: current_item.location?.CLcoordinates ?? CLLocationCoordinate2D(latitude: 1000, longitude: 1000)) {
                    MapAnnotationButton(item: current_item)
                }
            })
            .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil); self.showFilter = false })
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                    .frame(height: 10)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 0.5)
                    .foregroundColor(.gray)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                    .frame(width: 375, height: showFilter ? 300 : 60, alignment: .center)
                    .shadow(radius: 5)
                    .animation(suppressAnimation ? .none : .easeInOut(duration: 0.3))
                    .overlay(
                        VStack {
                            HStack {
                                Spacer()
                                    .frame(width: 15)
                                TextField("\(Image(systemName: "magnifyingglass"))  What are you looking for?", text: $keyword, onEditingChanged: { editing in
                                    print("editing: \(editing)")
                                }, onCommit: {
                                    UIApplication.shared.endEditing()
                                    print("Did commit: \(keyword)")
                                    DispatchQueue.global().async {
                                        self.products = backendClient.query(keyword: keyword)
                                    }
                                })
                                .foregroundColor((self.keyword == "") ? .gray : .black)
                                .font(.system(size: 17, weight: .semibold, design: .default))
                                .multilineTextAlignment(.leading)
                                //                            .frame(width: 250, height: 20, alignment: .center)
                                .padding(5)
                                Divider()
                                Button(action: {
                                    self.showFilter.toggle()
                                }, label: {
                                    Spacer()
                                        .frame(width: 20)
                                    
                                    Image(systemName: "slider.horizontal.3")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 25, weight: showFilter ? .bold : .regular))
                                        .frame(width: 30)
                                    Spacer()
                                        .frame(width: 20)
                                })
                                
                            }
                            .frame(width: 375, height: 60)
                            
                            if(showFilter) {
                                Divider()
                                HStack {
                                    Image(systemName: "dollarsign.circle")
                                        .font(.system(size:25))
                                        //                                            .foregroundColor(.gray)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 2)
                                    DualSlider(width: 200, minValue: $minPriceValue, maxValue: $maxPriceValue)
                                    Text("\(Int(round(minPriceValue * CGFloat(self.maxPrice))))€ - \(Int(round(maxPriceValue * CGFloat(self.maxPrice))))€")
                                        .font(.system(size: 15, weight: .semibold))
                                    Spacer()
                                }
                                HStack {
                                    Image(systemName: "mappin.and.ellipse")
                                        .font(.system(size:25))
                                        //                                            .foregroundColor(.gray)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 2)
                                    MonoSlider(width: 200, maxValue: $maxDistanceValue)
                                    Text("<= \(Int(round(maxDistanceValue * CGFloat(self.maxDistance))))km")
                                        .font(.system(size: 15, weight: .semibold))
                                    Spacer()
                                }
                                Spacer()
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
