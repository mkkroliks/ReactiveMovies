//
//  RankingPercentIndicator.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 12/10/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

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
