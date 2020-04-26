//
//  RatingView.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 25/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

struct RatingView: View {
    @State var percentage: CGFloat? = 0
    
    @State var shouldShow: Bool = false
    
    var percentageToShow: CGFloat {
        guard
            let percentage = percentage,
            shouldShow
        else {
            return 0
        }
        return percentage
    }
    
    var color: Color {
        guard let percentage = percentage else {
            return .gray
        }
        if percentage > 70 {
            return .green
        } else if percentage > 50 {
            return .orange
        } else {
            return .red
        }
    }
    
    var body: some View {
        ZStack {
            Circle()
                .opacity(0.8)
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .foregroundColor(color)
                Circle()
                    .stroke(lineWidth: 10)
                    .opacity(0.3)
                    .foregroundColor(.black)
                    .modifier(RankingPercentageIndicator(percentage: percentage!, color: color))
            }.padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
        }.frame(width:110, height: 110)
        .onAppear {
            withAnimation(.easeInOut(duration: 10.0)) {
                self.percentage = 90
            }
        }
    }
}


struct RankingPercentageIndicator: AnimatableModifier {
    var percentage: CGFloat
    var color: Color
    
    var animatableData: CGFloat {
        get { percentage }
        set { percentage = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(PercentageLabel(percentage: percentage).foregroundColor(.red))
            .overlay(PercentageLine(percentage: percentage, color: color))
    }
    
    struct PercentageLabel: View {
        var percentage: CGFloat
        
        var body: some View {
            HStack(alignment: .top) {
                Text("\(Int(percentage))").font(.system(size: 28)).foregroundColor(.white)
                Text("%").foregroundColor(.white)
                    .font(.system(size: 16))
                    .padding(EdgeInsets(top: 4, leading: -7, bottom: 0, trailing: 0))
            }
        }
    }
    
    struct PercentageLine: View {
        var percentage: CGFloat
        var color: Color
        var body: some View {
            Circle()
                .trim(from: 0, to: percentage / 100)
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .rotationEffect(.init(degrees: -90))
                .foregroundColor(color)
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView()
    }
}
