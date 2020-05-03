//
//  RatingView.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 25/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

struct RatingView: View {
    @State private var percent: CGFloat? = 0
    
    var percentToShow: Float? = 0
    
    var color: Color {
        guard let percent = percent else {
            return .gray
        }
        if percent > 70 {
            return .green
        } else if percent > 50 {
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
            withAnimation(.easeInOut(duration: 1.0)) {
                guard let percent = self.percentToShow else {
                    return
                }
                self.percent = CGFloat(percent)
            }
        }
    }
}


struct RankingPercentIndicator: AnimatableModifier {
    var percent: CGFloat?
    var color: Color
    
    var animatableData: CGFloat {
        get { percent ?? 0 }
        set { percent = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(PercentLabel(percent: percent).foregroundColor(.red))
            .overlay(PercentLine(percent: percent, color: color))
    }
    
    struct PercentLabel: View {
        var percent: CGFloat?
        
        var body: some View {
            ZStack {
                if percent != nil {
                    HStack(alignment: .top) {
                        Text("\(Int(percent!))")
                            .font(.system(size: 14)).bold()
                            .foregroundColor(.white)
                            .padding(.leading, 2)
                        Text("%").foregroundColor(.white)
                            .font(.system(size: 6))
                            .padding(EdgeInsets(top: 2, leading: -8, bottom: 0, trailing: 0))
                    }
                } else {
                    Text("\(Int(percent!))").font(.system(size: 14)).foregroundColor(.white)
                }
            }
        }
    }
    
    struct PercentLine: View {
        var percent: CGFloat?
        var color: Color
        var body: some View {
            Circle()
                .trim(from: 0, to: (percent ?? 0) / 100)
                .stroke(style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                .rotationEffect(.init(degrees: -90))
                .foregroundColor(color)
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(percentToShow: 96)
    }
}
