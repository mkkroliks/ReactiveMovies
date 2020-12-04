//
//  RatingView.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 25/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

struct RatingView: View {
    @State var percent: Float

    var color: Color {
        if percent > 70 {
            return .green
        } else if percent > 50 {
            return .yellow
        } else {
            return .red
        }
    }

    var animate: Bool = true

    var body: some View {
        ZStack {
            Circle()
                .opacity(0.8)
            ZStack {
                Circle()
                    .stroke(lineWidth: 3)
                    .foregroundColor(color)
                Circle()
                    .stroke(lineWidth: 3)
                    .opacity(0.3)
                    .foregroundColor(.black)
                    .modifier(RankingPercentIndicator(percent: percent, color: color))
            }.padding(EdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3))
        }
        .frame(width:40, height: 40)
        .onAppear {
            guard animate else {
                return
            }
            let finalPercent = percent
            percent = 0
            withAnimation(.easeInOut(duration: 5.0)) {
                self.percent = finalPercent
            }
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(percent: 91)
    }
}
