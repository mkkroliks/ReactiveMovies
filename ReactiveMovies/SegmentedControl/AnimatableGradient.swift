//
//  AnimatableGradient.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 12/11/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

struct AnimatableGradient: AnimatableModifier {
    let from: [UIColor]
    let to: [UIColor]
    var pct: CGFloat = 0
    
    var animatableData: CGFloat {
        get { pct }
        set { pct = newValue }
    }
    
    func body(content: Content) -> some View {
        var gColors = [Color]()
        
        for i in 0..<from.count {
            gColors.append(colorMixer(c1: from[i], c2: to[i], pct: pct))
        }
        
        return LinearGradient(gradient: Gradient(colors: gColors),
                              startPoint: UnitPoint(x: 0, y: 0),
                              endPoint: UnitPoint(x: 1, y: 1))
    }
    

    func colorMixer(c1: UIColor, c2: UIColor, pct: CGFloat) -> Color {
        guard var cc1 = c1.cgColor.components else { return Color(c1) }
        guard var cc2 = c2.cgColor.components else { return Color(c1) }
        
        if cc1.count < 3 {
            cc1 = [cc1[0]*255, cc1[0]*255, cc1[0]*255, cc1[1]]
        }
        
        if cc2.count < 3 {
            cc2 = [cc2[0]*255, cc2[0]*255, cc2[0]*255, cc2[1]]
        }
        
        let r = (cc1[0] + (cc2[0] - cc1[0]) * pct)
        let g = (cc1[1] + (cc2[1] - cc1[1]) * pct)
        let b = (cc1[2] + (cc2[2] - cc1[2]) * pct)
        
        return Color(red: Double(r), green: Double(g), blue: Double(b))
    }
}
