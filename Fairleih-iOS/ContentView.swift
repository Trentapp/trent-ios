//
//  ContentView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 11.05.21.
//

import SwiftUI
import MapKit

struct ContentView: View {
    
    @State var keyword = ""
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 52.516845532825634, longitude: 13.39), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
    
    var body: some View {
        NavigationView {
            ZStack(alignment: Alignment(horizontal: .center, vertical: .top), content: {
                Map(coordinateRegion: $region)
                    .edgesIgnoringSafeArea(.all)
                
                RoundedRectangle(cornerRadius: 20)
                    .stroke(lineWidth: 1)
                    .foregroundColor(.black)
                    .background(RoundedRectangle(cornerRadius: 20).fill(Color.white))
                    .frame(width: 250, height: 33, alignment: .center)
                    .overlay(
                        TextField("\(Image(systemName: "magnifyingglass")) What are you looking for?", text: $keyword)
                            .font(.system(size: 15, weight: .regular, design: .default))
                            .multilineTextAlignment(.center)
                            .frame(width: 250, height: 20, alignment: .center)
                            .padding(5)
                    )
                
                    
            })
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
