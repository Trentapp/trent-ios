//
//  ReviewView.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 25.06.21.
//

import SwiftUI

struct ReviewView: View {
    
    @State var userProfile: UserProfile?
    @State var reviews: [Review]?
    @State var isLoading = true
    
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            } else if (reviews ?? []).isEmpty {
                Text("No reviews yet")
                    .foregroundColor(.gray)
            } else {
                List {
                    ForEach(reviews ?? [] , id: \.self) { review in
                        VStack(alignment: .leading, spacing: 5) {
                            Text(review.title)
                                .font(.system(size: 20))
                                .bold()
                            HStack(alignment: .center, spacing: 1, content: {
                                ForEach(Range(uncheckedBounds: (lower: 0, upper: 5))) { index in
                                    let isStarFilled = (index+1) <= Int(round((userProfile?.rating)!))
                                    Image(systemName: isStarFilled ? "star.fill" : "star")

                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.yellow)
                                        .frame(width: 15, height: 15)
                                }
                                Spacer()
                            })
                            Text("From \(review.posterId)")
                                .foregroundColor(.gray)
                                .font(.system(size: 15))
                            Text(review.comment)
                            
                        }
                    }
                }
            }
        }
        .navigationBarTitle("Reviews", displayMode: .inline)
        .onAppear(){
            DispatchQueue.global().async {
                self.reviews = BackendClient.shared.getReviews(user_id: userProfile?._id ?? "")
                self.isLoading = false
            }
        }
    }
}
