//
//  RatingView.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 25/04/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

struct RatingView: View {
    
    var percentage: CGFloat? = 60
    
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
                Circle()
                    .trim(from: 0, to: percentageToShow / 100)
                    .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                    .rotationEffect(.init(degrees: -90))
                    .foregroundColor(color)
                    .animation(Animation.interpolatingSpring(stiffness: 40, damping: 10).delay(0.1))
                HStack(alignment: .top) {
                    if percentage != nil {
                        Text("\(Int(percentageToShow))").font(.system(size: 28)).foregroundColor(.white)
                        Text("%").foregroundColor(.white)
                            .font(.system(size: 16))
                            .padding(EdgeInsets(top: 4, leading: -7, bottom: 0, trailing: 0))
                    } else {
                        Text("NR").font(.system(size: 28)).foregroundColor(.white)
                    }
                }
            }.padding(EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12))
        }.frame(width:110, height: 110)
        .onAppear {
            self.shouldShow = true
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView()
    }
}
