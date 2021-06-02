//
//  ItemDetailView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 30.05.21.
//

import SwiftUI
import MapKit
import Introspect

struct ItemDetailView: View {
    @State var item: Product?
    @State var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 750, longitudinalMeters: 750)
    
    @State var tabBar: UITabBar?
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
            
            HStack {
                Spacer()
                Image(uiImage: UIImage(data: Data(base64Encoded: item?.pictures?.first ?? "") ?? Data()) ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 250)
    //                .padding(.bottom, -35)
    //                .ignoresSafeArea(.container, edges: .top)
                Spacer()
            }
            
            HStack {
                Text(item?.name ?? "Untitled item")
                    .font(.system(size: 30, weight: .semibold, design: .default))
                    .padding(.horizontal, 15)
                Spacer()
                VStack(alignment: .leading, spacing: 10, content: {
                    Text("\(String(format: "%.2f", round(100*(item?.prices?.perHour ?? 0))/100))€/hr")
                        .font(.system(size: 23, weight: .medium, design: .default))
                    HStack(alignment: .center, spacing: 0, content: {
//                        Text("5/5")
//                            .padding(.trailing, 5)
                        ForEach(Range(uncheckedBounds: (lower: 0, upper: 5))) { index in
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            
                        }
                    })
                })
                
                    .padding(.horizontal, 15)
            }
            
            Divider()
                .padding(.bottom, 10)
            
            Text(item?.desc ?? "")
                .font(.system(size: 22, weight: .regular, design: .default))
                .padding(.horizontal, 15)
            HStack{
                VStack(alignment: .leading, spacing: 3, content: {
                    Text((item?.address?.street ?? "Street") + " " + (item?.address?.houseNumber ?? "Number"))
                        .minimumScaleFactor(0.6)
                    Text((item?.address?.zipcode ?? "000000") + " " + (item?.address?.city ?? "City"))
                        .minimumScaleFactor(0.6)
                    Text(item?.address?.country ?? "Country")
                        .minimumScaleFactor(0.6)
                })
                .padding()
                Spacer()
                NavigationLink(
                    destination: Map(coordinateRegion: $coordinateRegion)
                        .ignoresSafeArea(.container, edges: .bottom)
                        .navigationBarTitle("\(item?.address?.street ?? "Street")  \(item?.address?.houseNumber ?? "0")")
//                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarHidden(false),
                    label: {
                        Map(coordinateRegion: $coordinateRegion, interactionModes: [], showsUserLocation: false, userTrackingMode: .none)
                            .frame(width: 200, height: 150)
                            .padding()
                    })
            }
            
            Spacer()
            Divider()
                .border(Color.black, width: 10)
            HStack{
                VStack(alignment: .center, spacing: nil, content: {
                    Text("15€")
                        .font(.system(size: 25))
                        .bold()
                    Text("Available")
                        .font(.system(size: 15))
                        .foregroundColor(.green)
                })
                .padding(.horizontal, 15)
                
                Spacer()
                Button(action: {
                    print("Requesting")
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
        })
        .padding(.bottom, -50)
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .introspectTabBarController { (UITabBarController) in
            self.tabBar = UITabBarController.tabBar
            self.tabBar?.isHidden = true
        }
        
        .onAppear(){
            self.tabBar?.isHidden = true
        }
    }
}

struct ItemDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ItemDetailView(item: Product(_id: "000", name: "Kärcher High Pressure Washer", desc: "Super Kärcher High Pressure Washer. Cleans surfaces amazingly. Lorem ipsum dolor sit amit", address: Address(street: "Some Street", houseNumber: "42c", zipcode: "69115", city: "Heidelberg", country: "Germany"), location: Coordinates(lat: 49.47, lng: 7.8), prices: Prices(perHour: 7.5, perDay: 20)))
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
