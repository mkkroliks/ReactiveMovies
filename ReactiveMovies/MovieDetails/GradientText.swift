//
//  GradientText.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 11/05/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

extension View {
    func foreground<Overlay: View>(_ overlay: Overlay) -> some View {
        _CustomForeground(overlay: overlay, for: self)
    }
}

struct _CustomForeground<Content: View, Overlay: View>: View {
    let content: Content
    let overlay: Overlay

    internal init(overlay: Overlay, for content: Content) {
        self.content = content
        self.overlay = overlay
    }

    var body: some View {
        content.overlay(overlay).mask(content)
    }
}

//extension View {
//    public func foreground<Overlay: View>(_ overlay: Overlay) -> some View {
//        self.overlay(overlay).mask(self)
//    }
//}

// MARK: - Example
struct GradientTextDemo: View {
    var body: some View {
        Text("Gradient foreground")
//        .bold()
            .foreground(makeGradient())
//            .padding(.horizontal, 32)
//            .padding(.vertical)
//            .background(Color.black)
//            .cornerRadius(12)
    }

    func makeGradient() -> some View {
        LinearGradient(
            gradient: .init(colors: [Color("SegmentedControlGradientStart"), Color("SegmentedControlGradientEnd")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct GradientTextDemo_Previews: PreviewProvider {
    static var previews: some View {
//        SegmentedControllView()
        GradientTextDemo()
    }
}
