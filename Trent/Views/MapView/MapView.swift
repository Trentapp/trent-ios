//
//  ContentView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 11.05.21.
//

import SwiftUI
import MapKit
import BottomSheet
import Sliders
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
    @State var filteredResults: [Product] = [] {
        didSet {
            if filteredResults.count > 0 {
                bottomSheetPosition = .middle
            } else {
                bottomSheetPosition = .hidden
            }
        }
    }
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
    
//    @State var minPriceValue: CGFloat = 0
//    @State var maxPriceValue: CGFloat = 1

    
    
//    @State var maxDistanceValue: CGFloat = 1
    
    
    // Slider Filter
    @State var priceRange: ClosedRange<CGFloat> = 0...1
    @State var maxDistance: CGFloat = 1
    
    @State var maxDistanceResults = 25
    @State var maxPriceResults = 100
    
    
    
    
    // Value cached from last time filter calculated
    @State var lastMinPrice: Int?
    @State var lastMaxPrice: Int?
    @State var lastMaxDistance: Int?
    
    @State var bottomSheetPosition: BottomSheetPosition = .hidden
    
    func query(location: CLLocationCoordinate2D) {
        self.cachedLocation = location
        BackendClient.shared.query(keyword: self.keyword, location: location, maxDistance: maxDistanceResults) { products, success in
            self.allResults = products ?? []
            //                                        for product in products ?? []  {
            //                                            let annotation = ProductAnnotation(item: product)
            //                                            self.allResults.append(annotation)
            //                                        }
            
//            DispatchQueue.global().async {
                var maxDistanceValue: CGFloat = 0
                var maxPriceValue: CGFloat = 0
                
                let originLocation = CLLocation(latitude: cachedLocation.latitude, longitude: cachedLocation.longitude)
                
                for product in self.allResults {
                    if (CGFloat(product.prices?.perDay ?? 0)/100) > maxPriceValue {
                        maxPriceValue = (CGFloat(product.prices?.perDay ?? 0) / 100)
                    }
                    
                    let itemLocation = CLLocation(latitude: product.location?.CLcoordinates.latitude ?? 0, longitude: product.location?.CLcoordinates.longitude ?? 0)
                    let distance = CGFloat(round(itemLocation.distance(from: originLocation) / 1000))
                    if maxDistanceValue < distance {
                        maxDistanceValue = distance
                    }
                }
//                DispatchQueue.main.async {
                    self.maxPriceResults = Int(maxPriceValue)
                    self.maxDistanceResults = Int(round(maxDistanceValue))
//                }
//            }
            
            if maxDistance == 1 && priceRange.upperBound == 1 && priceRange.lowerBound == 0 {
                filteredResults = allResults
            } else {
                filterResults()
            }
        }
    }
    
    func filterResults() {
        
        if maxDistance == 1 && priceRange.upperBound == 1 && priceRange.lowerBound == 0 {
            filteredResults = allResults
            return
        }
        
        DispatchQueue.global().async {
            
            var matches = [Product]() //[ProductAnnotation]()
            
            let minPrice = Double(Int(round(self.priceRange.lowerBound * CGFloat(self.maxPriceResults))))
            let maxPrice = Double(Int(round(self.priceRange.upperBound * CGFloat(self.maxPriceResults))))
            let maxDistance = Int(round(self.maxDistance * CGFloat(self.maxDistanceResults)))
            
            let originLocation = CLLocation(latitude: cachedLocation.latitude, longitude: cachedLocation.longitude)
            
            for item in allResults {
                //                let item = annotation.item
                
                let price = (item.prices?.perDay ?? 0) / 100
                let itemLocation = CLLocation(latitude: item.location?.CLcoordinates.latitude ?? 0, longitude: item.location?.CLcoordinates.longitude ?? 0)
                let distance = itemLocation.distance(from: originLocation)
                
                if price >= minPrice && price <= maxPrice && distance <= Double(maxDistance * 1000) {
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
                        self.bottomSheetPosition = .bottom
                    } label: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 12.5)
                                .foregroundColor((MapViewController.shared.currentlyFocusedItem == item) ? .black : .white)
                                .frame(width: 50, height: 25)
                            Text("\(Int((item.prices?.perDay ?? 0)/100))€")
                                .font(.system(size: 15, weight: .bold, design: .default))
                                .foregroundColor((viewController.currentlyFocusedItem == item) ? .white : .black)
                        }
                    }
                }
            })
            .gesture(DragGesture().onChanged{_ in UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil); self.showFilter = false
                if self.bottomSheetPosition != .hidden {
                    self.bottomSheetPosition = .bottom
                }
            })
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                    .frame(height: 10)
                RoundedRectangle(cornerRadius: 10)
                    .stroke(lineWidth: 0.5)
                    .foregroundColor(.gray)
                    .background(RoundedRectangle(cornerRadius: 10).fill(colorScheme == .dark ? Color(UIColor.systemGray4) : .white))
                    .frame(height: showFilter ? 170 : 60, alignment: .center)
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
                                    query(location: location)
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
                            .frame(height: 60)
                            
                            
                            VStack {
                                
                                Divider()
                                HStack {
                                    Image(systemName: "dollarsign.circle")
                                        .foregroundColor((colorScheme == .dark) ? .gray : .black)
                                        .font(.system(size:25))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 2)
                                    
//                                    DualSlider(minValue: $minPriceValue, maxValue: $maxPriceValue, width: 220) {
//                                        let minPrice = Int(round(self.minPriceValue * CGFloat(self.maxPriceResults)))
//                                        let maxPrice = Int(round(self.maxPriceValue * CGFloat(self.maxPriceResults)))
//
//                                        if (maxPrice != self.lastMaxPrice) || (minPrice != self.lastMinPrice){
//                                            filterResults()
//                                        }
//                                    }
                                    
                                    RangeSlider(range: $priceRange)
                                    Text("\(Int(round(priceRange.lowerBound * CGFloat(self.maxPriceResults))))€ - \(Int(round(priceRange.upperBound * CGFloat(self.maxPriceResults))))€")
                                        .foregroundColor((colorScheme == .dark) ? .gray : .black)
                                        .font(.system(size: 15, weight: .semibold))
                                    Spacer()
                                }
                                HStack {
                                    Image(systemName: "mappin.and.ellipse")
                                        .font(.system(size:25))
                                        .foregroundColor((colorScheme == .dark) ? .gray : .black)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 2)
//                                    MonoSlider(maxValue: $maxDistanceValue, width: 220) {
//                                        let maxDistance = Int(round(CGFloat(self.maxDistanceResults) * self.maxDistanceValue))
//
//                                        if maxDistance != self.lastMaxDistance {
//                                            filterResults()
//                                        }
//                                    }
                                    ValueSlider(value: $maxDistance)
                                    Text("<= \(Int(round(maxDistance * CGFloat(self.maxDistanceResults))))km")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundColor((colorScheme == .dark) ? .gray : .black)
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
                    .padding(.horizontal, 15)
                Spacer()
                DetailBottomView()
                Spacer()
                    .frame(height: (self.bottomSheetPosition == .hidden) ? 0 : 75)
            }
            
        })
        .bottomSheet(bottomSheetPosition: $bottomSheetPosition, options: [.appleScrollBehavior, /*.showCloseButton(action: {
                                                                          self.bottomSheetPosition = .bottom
                                                                          })*/], headerContent: {
                                                                            Text((self.filteredResults.count > 0) ? "\(self.filteredResults.count) Results" : "")
                                                                                .font(.system(size: 19))
                                                                                .bold()
                                                                            //                .hidden(self.bottomSheetPosition != BottomSheetPosition.bottom)
                                                                          }, mainContent: {
                                                                            VStack {
                                                                                ForEach(filteredResults, id: \.self) { item in
                                                                                    NavigationLink(destination: ItemDetailView(item: item)) {
                                                                                        VStack {
                                                                                            HStack{
                                                                                                Image(uiImage: item.thumbnailUIImage ?? UIImage())
                                                                                                    .resizable()
                                                                                                    .aspectRatio(contentMode: .fit)
                                                                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                                                                                    .frame(width: 75, height: 75)
                                                                                                    .padding()
                                                                                                VStack(alignment: .leading) {
                                                                                                    Text(item.name ?? "Product")
                                                                                                        .font(.system(size: 22))
                                                                                                        .foregroundColor(Color(UIColor.label))
                                                                                                        .bold()
                                                                                                    HStack {
                                                                                                        Text(item.desc ?? "")
                                                                                                            .foregroundColor(.gray)
                                                                                                        Spacer()
                                                                                                        VStack {
                                                                                                            Spacer()
                                                                                                            Text("\(Int((item.prices?.perDay ?? 0)/100))€/day")
                                                                                                                .font(.system(size: 17))
                                                                                                                .foregroundColor(Color(UIColor.label))
                                                                                                        }
                                                                                                    }
                                                                                                    Spacer()
                                                                                                }
                                                                                                .padding([.horizontal, .top])
                                                                                            }
                                                                                            Divider()
                                                                                        }
                                                                                        .frame(height: 100)
                                                                                    }
                                                                                    
                                                                                }
                                                                                NavigationLink(destination: EmptyView()) {
                                                                                    EmptyView()
                                                                                }
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
        .onChange(of: self.priceRange, perform: { value in
            self.filterResults()
        })
        .onChange(of: self.maxDistance, perform: { value in
            self.filterResults()
        })
    }
}


struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
