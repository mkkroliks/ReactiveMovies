//
//  RatingView.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 25/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

struct RatingView: View {
    @State private var percent: Float? = 0
    
    var percentToShow: Float? = 0
    
    var color: Color {
        guard let percent = percent else {
            return .gray
        }
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
//                    .overlay(PercentLabel1(percent: percent).foregroundColor(.red))
//                    .overlay(PercentLine1(percent: percent, color: color))
            }.padding(EdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3))
        }
        .frame(width:40, height: 40)
        .onAppear {
            withAnimation(animate ? .easeInOut(duration: 5.0) : nil) {
                guard let percent = self.percentToShow else {
                    return
                }
                self.percent = percent
            }
        }
    }
}

struct RatingView1_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(percentToShow: 96)
    }
}
