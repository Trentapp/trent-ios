//
//  BookingOverviewView.swift
//  Trent
//
//  Created by Fynn Kiwitt on 30.07.21.
//

import SwiftUI

import MapKit

struct BookingOverviewView: View {
    
    var model: BookingModelView
    
    @State var startDateString = ""
    @State var endDateString = ""
    
    @Binding var dontPopBack: Bool
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    Text(model.item.name ?? "Item")
                        .font(.system(size: 24))
                        .bold()
                        .padding([.horizontal, .top])
                    Text("\(startDateString) - \(endDateString)")
                        .padding(.horizontal)
                    ImageView(images: model.item.picturesUIImage)
                    HStack {
                        ((model.item.user?.pictureUIImage != nil) ? Image(uiImage: (model.item.user?.pictureUIImage!)!) : Image(systemName: "person.crop.circle"))
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .opacity((model.item.user?.pictureUIImage != nil) ? 1 : 0.5)
                            .clipShape(Circle())
                            .foregroundColor(.gray)
                            .frame(width: 50, height: 50)
                            .padding()
                        VStack(alignment: .leading, spacing: 4) {
                            Text((model.item.user?.name ?? "Product owner") + ((model.item.user?._id ?? "") == (UserObjectManager.shared.user?._id ?? "") ? " (Me)" : ""))
                                .font(.system(size: 20, weight: .regular, design: .default))
                                .foregroundColor(Color.black)
                        }
                        Spacer()
                    }
                    HStack{
                        AddressView(address: model.item.address)
                            .padding(.leading)
                        Spacer()
                        Button(action: {
                            let place = MKPlacemark(coordinate: model.item.location?.CLcoordinates ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
                            
                            let mapItem = MKMapItem(placemark: place)
                            mapItem.name = (model.item.address != nil) ?  "\(model.item.address?.streetWithNr ?? ""), \(model.item.address?.zipcode ?? "") \(model.item.address?.city ?? "")" : model.item.name ?? ""
                            mapItem.openInMaps(launchOptions: nil)
                        }, label: {
                            //                                Map(coordinateRegion: $coordinateRegion, interactionModes: [], showsUserLocation: false, userTrackingMode: .none)
                            //                                    .frame(width: 200, height: 150)
                            //                                    .padding()
                            Map(coordinateRegion: .constant(MKCoordinateRegion(center: model.item.location?.CLcoordinates ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 750, longitudinalMeters: 750)), interactionModes: [], annotationItems: [model.item], annotationContent: { current_item in
                                MapMarker(coordinate: current_item.location?.CLcoordinates ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
                            })
                            .frame(width: 150, height: 100)
                            .padding()
                        })
                    }
                    //            Spacer()
                    
                    Group() {
                        Text("\(model.duration)x \(String(format: "%.02f", model.item.prices?.perDay ?? 0))")
                        Divider()
                            .frame(width: 200)
                        HStack {
                            Text("= \(String(format: "%.02f", model.totalPrice))")
                                .font(.system(size: 18, weight: .bold))
                            Text("incl. VAT")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.leading)
                }
            }
            Button {
                BackendClient.shared.addTransaction(item_id: model.item._id, startDate: model.startDate, endDate: model.endDate) { success in
                    if success {
                        MainViewProperties.shared.selectedItem = tabBarConfigurations[2]
                        MainViewProperties.shared.showInfo(with: "Booked")
                        dontPopBack = false
                    }
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(.blue)
                    Text("Book now")
                        .bold()
                        .foregroundColor(.white)
                }
                .frame(height: 45)
                .padding([.horizontal, .top])
            }
            Text("Approval of owner still needed.")
                .font(.system(size: 10))
                .italic()
                .foregroundColor(.gray)
            
        }
        .navigationBarTitle("Overview", displayMode: .large)
        .onAppear() {
            startDateString = model.startDate.hrString
            endDateString = model.endDate.hrString
        }
    }
}

//struct BookingOverviewView_Previews: PreviewProvider {
//    static var previews: some View {
//        BookingOverviewView(model: BookingModelView(item: Product(_id: "")))
//    }
//}
