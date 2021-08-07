//
//  ItemDetailView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 30.05.21.
//

import SwiftUI
import MapKit
//import Introspect

struct ItemDetailView: View {
    
    @State var model = BookingModelView(item: Product(_id: ""))
    @State var item: Product?
    
    @State var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 750, longitudinalMeters: 750)
    @State var isLoading = false
    @State var updated = false
    
    @State var showAuthentication = false
    @State var showBooking = false
    
//    @State var tabBar: UITabBar?
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 10, content: {
            HStack{
                Button(action: {
                    presentation.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                })
                .frame(width: 25, height: 40)
                .padding(.leading, 20)
                .padding(.trailing, 10)
                .padding(.horizontal, 5)
                Divider()
                Spacer()
            }
            .frame(height: 45)
            .padding(.vertical, -10)
            Divider()
                .padding(.bottom, -20)
            ScrollView{
                VStack(alignment: .leading, spacing: 10, content: {
                    ZStack {
                        ImageView(images: item?.picturesUIImage ?? [UIImage]())
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .hidden(!isLoading)
                    }
                    .padding(.top, -10)

                    HStack {
                        Text(item?.name ?? "Untitled item")
                            .font(.system(size: 30, weight: .semibold, design: .default))
                            .padding(.horizontal, 15)
                        Spacer()
                        VStack(alignment: .leading, spacing: 10, content: {
                            Spacer()
                            Text("\(String(format: "%.2f", round(100*(item?.prices?.perDay ?? 0))/100))€/day")
                                .font(.system(size: 23, weight: .medium, design: .default))
                        })

                        .padding(.horizontal, 15)
                    }

                    Divider()
                        .padding(.bottom, 10)

                    Text(item?.desc ?? "")
                        .font(.system(size: 22, weight: .regular, design: .default))
                        .padding(.horizontal, 15)
                    HStack{
                        AddressView(address: item?.address)
                        .padding()
                        Spacer()
                        Button(action: {
                            let place = MKPlacemark(coordinate: item?.location?.CLcoordinates ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))

                            let mapItem = MKMapItem(placemark: place)
                            mapItem.name = (item?.address != nil) ?  "\(item?.address?.street ?? "") \(item?.address?.houseNumber ?? ""), \(item?.address?.zipcode ?? "") \(item?.address?.city ?? "")" : item?.name ?? ""
                            mapItem.openInMaps(launchOptions: nil)
                        }, label: {
                                //                                Map(coordinateRegion: $coordinateRegion, interactionModes: [], showsUserLocation: false, userTrackingMode: .none)
                                //                                    .frame(width: 200, height: 150)
                                //                                    .padding()
                            Map(coordinateRegion: $coordinateRegion, interactionModes: [], annotationItems: [item ?? Product(_id: "")], annotationContent: { current_item in
                                    MapMarker(coordinate: current_item?.location?.CLcoordinates ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
                                })
                                .frame(width: 150, height: 100)
                                .padding()
                            })
                    }
                    
                    HStack {
                        NavigationLink(destination: UserProfilePageView(userProfile: item?.user), label: {
                            ((item?.user?.pictureUIImage != nil) ? Image(uiImage: (item?.user?.pictureUIImage!)!) : Image(systemName: "person.crop.circle"))
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .opacity((item?.user?.pictureUIImage != nil) ? 1 : 0.5)
                                .clipShape(Circle())
                                .foregroundColor(.gray)
                                .frame(width: 50, height: 50)
                                .padding()
                            VStack(alignment: .leading, spacing: 4) {
                                Text((item?.user?.name ?? "Product owner") + ((item?.user?._id ?? "") == (UserObjectManager.shared.user?._id ?? "") ? " (Me)" : ""))
                                    .font(.system(size: 20, weight: .regular, design: .default))
                                    .foregroundColor(Color.black)
                                if (item?.user?.numberOfRatings ?? 0) >= 5 {
                                    HStack(alignment: .center, spacing: 2, content: {
                                        //                        Text("5/5")
                                        //                            .padding(.trailing, 5)
                                        ForEach(Range(uncheckedBounds: (lower: 0, upper: 5))) { index in
                                            let isStarFilled = (index+1) <= Int(round((item?.user?.rating)!))
                                            Image(systemName: isStarFilled ? "star.fill" : "star")

                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .foregroundColor(.yellow)
                                                .frame(width: 20, height: 20)
                                            //                                        .padding()
                                            
                                        }
                                    })
                                } else {
                                   Text("Not enough ratings")
                                    .italic()
                                    .font(.system(size: 13, weight: .regular, design: .default))
                                    .foregroundColor(Color.gray)
                                }
                                
                            }
                        })
                        
                        Spacer()
                        
                        NavigationLink(destination: ContactView(user: item?.user, product: item), label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.blue, lineWidth: 1)
                                    .frame(width: 100, height:40)
                                Text("Contact")
//                                    .bold()
                                    .foregroundColor(.blue)
                            }
                        })
                        .padding()
                        .hidden((item?.user?._id ?? "") == (UserObjectManager.shared.user?._id ?? "0"))
                    }
                })
            }
            
            NavigationLink("Booking", destination: BookingView(model: model), isActive: $showBooking).hidden(true)
            
            Spacer()
            Divider()
                .border(Color.black, width: 10)
            HStack{
//                VStack(alignment: .center, spacing: nil, content: {
//                    Text("15€")
//                        .font(.system(size: 25))
//                        .bold()
//                    Text("Available")
//                        .font(.system(size: 15))
//                        .foregroundColor(.green)
//                })
//                .padding(.horizontal, 15)

                Spacer()
                Button(action: {
                    print("Requesting")
                    if UserObjectManager.shared.loggedIn {
                        if item != nil {
                            self.model.item = item!
                            showBooking = true
                        }
                    } else {
                        showAuthentication = true
                    }
                    // BackendClient: addTransaction
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 100, height:40)
                        Text("Book")
                            .bold()
                            .foregroundColor(.white)
                    }
                })
                .padding(.horizontal, 15)
            }
            .padding(.bottom, 0)
        })
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
//        .introspectTabBarController { (UITabBarController) in
//            self.tabBar = UITabBarController.tabBar
//            self.tabBar?.isHidden = true
//        }
        
        .onAppear(){
//            self.tabBar?.isHidden = true
            if !updated {
                isLoading = true
                let itemId = item?._id ?? ""
                BackendClient.shared.getProduct(for: itemId) { item in
                    isLoading = false
                    if item != nil {
                        self.item = item!
                    }
                }
                self.coordinateRegion = MKCoordinateRegion(center: item?.location?.CLcoordinates ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 750, longitudinalMeters: 750)
                self.updated = true
            }
        }
        .fullScreenCover(isPresented: $showAuthentication, content: { AuthenticationView(wantedTab: nil) })
        .onChange(of: MainViewProperties.shared.popToRootView , perform: { value in
            if value {
                showBooking = false
            }
        })
    }
}

struct ImageView: View {
    
    var images: [UIImage]
    
    var body: some View {
        HStack {
            Spacer()
            TabView {
                ForEach((0..<images.count), id: \.self){ i in
                    Image(uiImage: images[i])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: 250)
            //                .padding(.bottom, -35)
            //                .ignoresSafeArea(.container, edges: .top)
            Spacer()
        }
    }
}

struct AddressView: View {
    
    @State var address: Address?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3, content: {
            Text(address?.firstLine ?? "")
                .minimumScaleFactor(0.8)
            Text(address?.secondLine ?? "")
                .minimumScaleFactor(0.8)
            Text(address?.thirdLine ?? "")
                .minimumScaleFactor(0.8)
        })

    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(item: Product(_id: "000", user: UserProfile(_id: "", name: ""), name: "Kärcher High Pressure Washer", desc: "Super Kärcher High Pressure Washer. Cleans surfaces amazingly. Lorem ipsum dolor sit amit", address: Address(street: "Some Street", houseNumber: "42c", zipcode: "69115", city: "Heidelberg", country: "Germany"), location: Coordinates(coordinates: [7.8, 49.47]), prices: Prices(perHour: 7.5, perDay: 20)))
    }
}
