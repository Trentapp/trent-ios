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
    
    @Environment(\.presentationMode) var presentation
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var locationManager = LocationManager.shared
    @ObservedObject var viewController = MapViewController.shared
    
    @State var keyword = ""
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 49.40806, longitude: 8.679158) , span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
    @State var cachedLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
//    @State var trackUser = MKUserTrackingMode.follow
    @State var trackUser = MapUserTrackingMode.follow
//    @State var allResults: [ProductAnnotation] = []
//    @State var filteredResults: [ProductAnnotation] = []
    @State var allResults: [Product] = []
    @State var filteredResults: [Product] = []
    @State var allowedToSet = true
    @State var annotationsChanged = false
    
    @State var showFilter = false {
        willSet {
            suppressAnimation = false
        }
        
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.301) {
                suppressAnimation = true
            }
        }
    }
    
    @State var suppressAnimation = true
    
    // Filter
    @State var maxPriceResults = 100.0
    @State var minPriceValue: CGFloat = 0
    @State var maxPriceValue: CGFloat = 1
    
    
    var maxDistanceResults = 25
    @State var maxDistanceValue: CGFloat = 1
    
    
    
    // Value cached from last time filter calculated
    @State var lastMinPrice: Int?
    @State var lastMaxPrice: Int?
    @State var lastMaxDistance: Int?
    
    func query(location: CLLocationCoordinate2D) {
        BackendClient.shared.query(keyword: self.keyword, location: location, maxDistance: maxDistanceResults) { products, success in
            self.allResults = products ?? []
//                                        for product in products ?? []  {
//                                            let annotation = ProductAnnotation(item: product)
//                                            self.allResults.append(annotation)
//                                        }
            if maxDistanceValue == 1 && maxPriceValue == 1 && minPriceValue == 0 {
                filteredResults = allResults
            } else {
                filterResults()
            }
        }
    }
    
    func filterResults() {
        DispatchQueue.global().async {
            var matches = [Product]() //[ProductAnnotation]()
            
            let minPrice = Double(Int(round(self.minPriceValue * CGFloat(self.maxPriceResults))))
            let maxPrice = Double(Int(round(self.maxPriceValue * CGFloat(self.maxPriceResults))))
            let maxDistance = Int(round(CGFloat(self.maxDistanceResults) * self.maxDistanceValue))
            
            let originLocation = CLLocation(latitude: cachedLocation.latitude, longitude: cachedLocation.longitude)
            
            for item in allResults {
//                let item = annotation.item
                
                let price = item.prices?.perDay ?? 0
                let itemLocation = CLLocation(latitude: item.location?.CLcoordinates.latitude ?? 0, longitude: item.location?.CLcoordinates.longitude ?? 0)
                let distance = itemLocation.distance(from: originLocation)
                
                if price >= minPrice && price <= maxPrice && distance <= Double(maxDistance * 0) {
                    matches.append(item)
                }
            }
            
            DispatchQueue.main.async {
                self.filteredResults = matches
            }
            
            lastMinPrice = Int(minPrice)
            lastMaxPrice = Int(maxPrice)
            lastMaxDistance = maxDistance
        }
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
//            MapKitView(userTrackingMode: $trackUser, region: $region, annotationItems: self.$filteredResults)
            Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $trackUser, annotationItems: self.filteredResults, annotationContent: { item in
                MapAnnotation(coordinate: item.location?.CLcoordinates ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)) {
                    Button {
                        viewController.currentlyFocusedItem = item
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 12.5)
                                .foregroundColor((MapViewController.shared.currentlyFocusedItem == item) ? .black : .white)
                                .frame(width: 50, height: 25)
                            Text("\(Int(item.prices?.perDay ?? 0))€")
                                .font(.system(size: 15, weight: .bold, design: .default))
                                .foregroundColor((viewController.currentlyFocusedItem == item) ? .white : .black)
                        }
                    }
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
                    .background(RoundedRectangle(cornerRadius: 10).fill(colorScheme == .dark ? Color(UIColor.systemGray4) : .white))
                    .frame(width: 375, height: showFilter ? 170 : 60, alignment: .center)
                    .shadow(radius: 5)
                    .animation(suppressAnimation ? .none : .easeInOut(duration: 0.3))
                    .overlay(
                        VStack {
                            Spacer()
                                .frame(height: 2.5)
                            HStack {
                                Spacer()
                                    .frame(width: 15)
                                Button {
                                    self.presentation.wrappedValue.dismiss()
                                } label: {
                                    Image(systemName: "chevron.backward")
                                        .foregroundColor(Color(UIColor.label))
                                }
                                
                                TextField("\(Image(systemName: "magnifyingglass"))  What are you looking for?", text: $keyword, onEditingChanged: { editing in
                                }, onCommit: {
                                    UIApplication.shared.endEditing()
                                    trackUser = .none
                                    
                                    let location = region.center
                                    self.cachedLocation = location
                                    query(location: cachedLocation)
                                })
                                .foregroundColor((self.keyword == "") ? .gray : Color(UIColor.label))
                                .font(.system(size: 17, weight: .semibold, design: .default))
                                .multilineTextAlignment(.leading)
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
                            
                            
                                VStack {
                                    
                                    Divider()
                                    HStack {
                                        Image(systemName: "dollarsign.circle")
                                            .foregroundColor(.gray)
                                            .font(.system(size:25))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 2)
                                        DualSlider(minValue: $minPriceValue, maxValue: $maxPriceValue, width: 220) {
                                            let minPrice = Int(round(self.minPriceValue * CGFloat(self.maxPriceResults)))
                                            let maxPrice = Int(round(self.maxPriceValue * CGFloat(self.maxPriceResults)))
                                            
                                            if (maxPrice != self.lastMaxPrice) || (minPrice != self.lastMinPrice){
                                                filterResults()
                                            }
                                        }
                                        Text("\(Int(round(minPriceValue * CGFloat(self.maxPriceResults))))€ - \(Int(round(maxPriceValue * CGFloat(self.maxPriceResults))))€")
                                            .foregroundColor(.gray)
                                            .font(.system(size: 15, weight: .semibold))
                                        Spacer()
                                    }
                                    HStack {
                                        Image(systemName: "mappin.and.ellipse")
                                            .font(.system(size:25))
                                            .foregroundColor(.gray)
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 2)
                                        MonoSlider(maxValue: $maxDistanceValue, width: 220) {
                                            let maxDistance = Int(round(CGFloat(self.maxDistanceResults) * self.maxDistanceValue))
                                            
                                            if maxDistance != self.lastMaxDistance {
                                                filterResults()
                                            }
                                        }
                                        Text("<= \(Int(round(maxDistanceValue * CGFloat(self.maxDistanceResults))))km")
                                            .font(.system(size: 15, weight: .semibold))
                                            .foregroundColor(.gray)
                                        Spacer()
                                    }
                                    Spacer()
                                    
                                    
                                }
                                .frame(height: showFilter ? 110 : 0)
                                .scaleEffect(CGSize(width: 1, height: showFilter ? 1 : 0), anchor: .top)
                                .opacity(showFilter ? 1 : 0)
                                .animation(suppressAnimation ? .none : .easeInOut(duration: 0.3))
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
        .onAppear() {
            LocationManager.shared.requestAuthorization()
            if trackUser == MapUserTrackingMode.follow {
                self.region.center = locationManager.currentLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
                MapViewController.shared.currentlyFocusedItem = nil
                LocationManager.shared.notifyOnNextUpdate {
                    let location = LocationManager.shared.currentLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
                    self.region.center = location
                    query(location: location)
                }
            }
        }
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
