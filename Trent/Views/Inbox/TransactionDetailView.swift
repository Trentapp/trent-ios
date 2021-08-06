//
//  TransactionDetailView.swift
//  Trent
//
//  Created by Fynn Kiwitt on 06.08.21.
//

import SwiftUI
import MapKit

struct TransactionDetailView: View {
    var transaction: Transaction
    @State var amILender = true
    @State var relevantUser: UserProfile?
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(transaction.product?.name ?? "Product Name")
                .font(.system(size: 20, weight: .bold))
                .padding()
            Text("From: \(transaction.dateStartDate?.hrString ?? "")")
                .padding(.horizontal)
            Text("Until: \(transaction.dateEndDate?.hrString ?? "")")
                .padding(.horizontal)
            
            Spacer()
                .frame(height: 20)
            
            if amILender {
                Text("Total earning: 20.50€")
                    .bold()
                    .padding(.horizontal)
            }
            
            Spacer()
                .frame(height: 100)
            HStack {
                NavigationLink(destination: Text("")/*UserProfilePageView(userProfile: item?.user)*/, label: {
                    ((relevantUser?.pictureUIImage != nil) ? Image(uiImage: (relevantUser?.pictureUIImage!)!) : Image(systemName: "person.crop.circle"))
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .opacity((relevantUser?.pictureUIImage != nil) ? 1 : 0.5)
                        .clipShape(Circle())
                        .foregroundColor(.gray)
                        .frame(width: 50, height: 50)
                        .padding()
                    VStack(alignment: .leading, spacing: 4) {
                        Text((relevantUser?.name ?? "Product owner") + ((relevantUser?._id ?? "") == (UserObjectManager.shared.user?._id ?? "") ? " (Me)" : ""))
                            .font(.system(size: 20, weight: .regular, design: .default))
                            .foregroundColor(Color.black)
                        if amILender {
                            if (transaction.product?.user?.numberOfRatings ?? 0) >= 5 {
                                HStack(alignment: .center, spacing: 2, content: {
                                    //                        Text("5/5")
                                    //                            .padding(.trailing, 5)
                                    ForEach(Range(uncheckedBounds: (lower: 0, upper: 5))) { index in
                                        let isStarFilled = (index+1) <= Int(round((transaction.product?.user?.rating)!))
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
                    }
                })
                
                if !amILender {
                    HStack{
                        AddressView(address: transaction.product?.address)
                            .padding(.leading)
                        Spacer()
                        Button(action: {
                            let place = MKPlacemark(coordinate: transaction.product?.location?.CLcoordinates ?? CLLocationCoordinate2D(latitude: 1000, longitude: 1000))
                            
                            let mapItem = MKMapItem(placemark: place)
                            mapItem.name = (transaction.product?.address != nil) ?  "\(transaction.product?.address?.street ?? "") \(transaction.product?.address?.houseNumber ?? ""), \(transaction.product?.address?.zipcode ?? "") \(transaction.product?.address?.city ?? "")" : transaction.product?.name ?? ""
                            mapItem.openInMaps(launchOptions: nil)
                        }, label: {
                            //                                Map(coordinateRegion: $coordinateRegion, interactionModes: [], showsUserLocation: false, userTrackingMode: .none)
                            //                                    .frame(width: 200, height: 150)
                            //                                    .padding()
                            Map(coordinateRegion: .constant(MKCoordinateRegion(center: transaction.product?.location?.CLcoordinates ?? CLLocationCoordinate2D(latitude: 1000, longitude: 1000), latitudinalMeters: 750, longitudinalMeters: 750)), interactionModes: [], annotationItems: [transaction.product ?? Product(_id:"")], annotationContent: { current_item in
                                MapMarker(coordinate: current_item.location?.CLcoordinates ?? CLLocationCoordinate2D(latitude: 1000, longitude: 1000))
                            })
                            .frame(width: 150, height: 100)
                            .padding()
                        })
                    }
                }
                
                Spacer()
                
                NavigationLink(destination: ContactView(), label: {
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
            }
            
            HStack { Spacer() }
            Spacer()
        }
        .navigationBarTitle("", displayMode: .inline)
        .onAppear() {
            self.amILender = (transaction.lender?._id ?? "" == UserObjectManager.shared.user?._id ?? "0")
            self.relevantUser = self.amILender ? transaction.borrower : transaction.lender
        }
    }
}

struct TransactionDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        TransactionDetailView(transaction: Transaction(_id: "", lender: nil, borrower: UserProfile(_id: "", name: "John Doe", inventory: [], rating: 0, numberOfRatings: 0, picture: nil), product: Product(_id: "", user: nil, name: "Product", desc: "Description", address: Address(street: "Begrheimer Straße", houseNumber: "88", zipcode: "69115", city: "Heidelberg", country: "Germany"), location: Coordinates(coordinates: [47, 7]), prices: Prices(perHour: 12, perDay: 50), thumbnail: nil, pictures: []), startDate: "", endDate: "", status: 1, totalPrice: 20))
    }
}
