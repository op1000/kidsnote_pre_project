//
//  RatingView.swift
//  kidsnote_pre_project
//
//  Created by Nakcheon Jung on 8/1/24.
//

import SwiftUI

struct RatingView: View {
    var rating: CGFloat
    var maxRating: Int
    var body: some View {
        let stars = HStack(spacing: 0) {
            ForEach(0..<maxRating, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        stars.overlay(
            GeometryReader { geo in
                let width = rating / CGFloat(maxRating) * geo.size.width
                ZStack(alignment: .leading) {
                    Rectangle()
                        .frame(width: width)
                        .foregroundColor(.yellow)
                }
            }
                .mask(stars)
        )
        .foregroundColor(.gray)
    }
}

#Preview {
    RatingView(rating: 4.6, maxRating: 5)
}
