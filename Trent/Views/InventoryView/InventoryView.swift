//
//  InventoryView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 30.05.21.
//

import SwiftUI
//import Introspect

struct InventoryView: View {
    
    @ObservedObject var userObjectManager = UserObjectManager.shared
    @State var showAddProduct = false
    @State var showAuthentication = false
    @State var showError = false
    
    //    @State var tabBar: UITabBar?
    
    var body: some View {
        ScrollView{
            VStack {
                Button(action: {
                    if userObjectManager.loggedIn {
                        if userObjectManager.user?.address != nil {
                            showAddProduct = true
                        } else {
                            showError = true
                        }
                    } else {
                        showAuthentication = true
                    }
                }, label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.green)
                        HStack {
                            ZStack{
                                Circle()
                                    .foregroundColor(.white)
                                    .frame(width: 20, height: 20)
                                Image(systemName: "plus")
                                    .font(.system(size: 15, weight: .bold, design: .default))
                                    .foregroundColor(.green)
                            }
                            Text("Add new item")
                                .bold()
                                .foregroundColor(.white)
                            //                            RoundedRectangle(cornerRadius: 10)
                            //                                .frame(width: 100, height:40)
                            //                                .stroke(Color.purple, lineWidth: 5)
                            
                        }
                    }
                })
                .frame(height: 50)
                .padding()
                InventoryCollectionView(items: userObjectManager.user?.inventory ?? [])
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showAuthentication, content: { AuthenticationView(wantedTab: nil) })
        .sheet(isPresented: $showAddProduct, content: {
//            ZStack {
//                if (userObjectManager.user?.address != nil) {
                    AddProductView()
//                } else {
//                    AddAddressView()
//                }
//            }
        })
        .navigationBarTitle(Text("Inventory"), displayMode: .large)
        .navigationViewStyle(StackNavigationViewStyle())
        //        .introspectTabBarController { (UITabBarController) in
        //            self.tabBar = UITabBarController.tabBar
        //        }
        .onAppear() {
            //            self.tabBar?.isHidden = false
            //            UserObjectManager.shared.refresh()
        }
        .alert(isPresented: $showError, content: {
            Alert(title: Text("Add address first"), message: Text("Please add your address first: Account > Edit Profile"), dismissButton: .default(Text("Okay")))
        })
        
    }
}

struct InventoryView_Previews: PreviewProvider {
    static var previews: some View {
        InventoryView()
    }
}
