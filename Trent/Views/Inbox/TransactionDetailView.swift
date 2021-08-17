//
//  TransactionDetailView.swift
//  Trent
//
//  Created by Fynn Kiwitt on 06.08.21.
//

import SwiftUI
import MapKit

struct TransactionDetailView: View {
    @State var transaction: Transaction
    @State var amILender = true
    @State var relevantUser: UserProfile?
    @State var showError = false
    
    @Environment(\.presentationMode) var presentationMode
    
    func updateTransaction() {
        BackendClient.shared.getTransaction(transactionId: self.transaction._id) { transaction in
            if transaction != nil {
                self.transaction = transaction!
                setViewVariables()
            }
        }
    }
    
    func setViewVariables() {
        self.amILender = (transaction.lender?._id ?? "" == UserObjectManager.shared.user?._id ?? "0")
        self.relevantUser = self.amILender ? transaction.borrower : transaction.lender
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(transaction.product?.name ?? "Product Name")
                    .font(.system(size: 20, weight: .bold))
                    .padding()
                
                Spacer()
                
                if transaction.status == 0 {
                    Text("Pending")
                        .padding(.trailing)
                        .foregroundColor(.gray)
                } else if transaction.status == 1 {
                    Text("Declined")
                        .padding(.trailing)
                        .foregroundColor(.red)
                } else if transaction.status == 2 {
                    Text("Accepted" + (amILender ? "" : " by owner"))
                        .padding(.trailing)
                        .foregroundColor(.green)
                }
            }
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
                NavigationLink(destination: UserProfilePageView(userProfile: relevantUser), label: {
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
                            .foregroundColor(Color(UIColor.label))
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
                
                Spacer()
                
                NavigationLink(destination: ContactView(user: relevantUser, product: transaction.product), label: {
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
            
            if !amILender {
                HStack{
                    AddressView(address: transaction.product?.address)
                        .padding(.leading)
                    Spacer()
                    Button(action: {
                        let place = MKPlacemark(coordinate: transaction.product?.location?.CLcoordinates ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
                        
                        let mapItem = MKMapItem(placemark: place)
                        mapItem.name = (transaction.product?.address != nil) ?  "\(transaction.product?.address?.streetWithNr ?? ""), \(transaction.product?.address?.zipcode ?? "") \(transaction.product?.address?.city ?? "")" : transaction.product?.name ?? ""
                        mapItem.openInMaps(launchOptions: nil)
                    }, label: {
                        //                                Map(coordinateRegion: $coordinateRegion, interactionModes: [], showsUserLocation: false, userTrackingMode: .none)
                        //                                    .frame(width: 200, height: 150)
                        //                                    .padding()
                        Map(coordinateRegion: .constant(MKCoordinateRegion(center: transaction.product?.location?.CLcoordinates ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), latitudinalMeters: 750, longitudinalMeters: 750)), interactionModes: [], annotationItems: [transaction.product ?? Product(_id:"")], annotationContent: { current_item in
                            MapMarker(coordinate: current_item.location?.CLcoordinates ?? CLLocationCoordinate2D(latitude: 0, longitude: 0))
                        })
                        .frame(width: 150, height: 100)
                        .padding()
                    })
                }
            }
            
            Group {
                HStack { Spacer() }
                Spacer()
            }
            
            HStack {
                if ((transaction.status == 0) && amILender) {
                    Button(action: {
                        BackendClient.shared.setTransactionStatus(transactionId: transaction._id, transactionStatus: 2) { success in
                            updateTransaction()
                            if !success {
                                showError = true
                            } else {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }, label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(.green)
                            Text("Accept")
                                .foregroundColor(.white)
                                .bold()
                        }
                    })
                }
                
                if transaction.status == 0 {
                Button(action: {
                    BackendClient.shared.setTransactionStatus(transactionId: transaction._id, transactionStatus: 1) { success in
                        updateTransaction()
                        if !success {
                            showError = true
                        } else {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(.red)
                        Text("Cancel")
                            .foregroundColor(.white)
                            .bold()
                    }
                })
                } else if transaction.status == 2 && transaction.isPaid != nil {
                    if !transaction.isPaid! {
                    NavigationLink(
                        destination: PaymentView(model: PaymentViewModel(transaction: transaction)),
                        label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(.blue)
                                Text("Pay now")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                        })
                    }
                }
            }
            .frame(height: 50)
            .padding(.horizontal)
            
        }
        .navigationBarTitle("", displayMode: .inline)
        .onAppear() {
            setViewVariables()
        }
        .alert(isPresented: $showError, content: {
            Alert(title: Text("Something went wrong"), message: Text("Please try again later."), dismissButton: .default(Text("Okay")))
        })
    }
}

struct TransactionDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        TransactionDetailView(transaction: Transaction(_id: "", lender: nil, borrower: UserProfile(_id: "", name: "John Doe", inventory: [], rating: 0, numberOfRatings: 0, picture: nil), product: Product(_id: "", user: nil, name: "Product", desc: "Description", address: Address(streetWithNr: "Begrheimer Straße 88", zipcode: "69115", city: "Heidelberg", country: "Germany"), location: Coordinates(coordinates: [47, 7]), prices: Prices(perHour: 12, perDay: 50), thumbnail: nil, pictures: []), startDate: "", endDate: "", status: 1, totalPrice: 20))
    }
}
