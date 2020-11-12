//
//  SegmentedControllView.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 03/05/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

struct SegmentedControlView: View {

    @State private var selectedIndex: Int = 0 {
        didSet {
            wer.wrappedValue = selectedIndex
        }
    }

    @State private var w: [CGFloat] = [0, 0, 0]

    @State private var height: CGFloat = 0

    var categories: [String] = ["Now Playing", "Upcoming", "Top Rated"]
    
    @State var isGradient = true

    let gradient1: [UIColor] = [.black, .black]
    let gradient2: [UIColor] = [UIColor(named: "SegmentedControlGradientStart")!, UIColor(named: "SegmentedControlGradientEnd")!]
    
    var wer: Binding<Int>
    
    init(value: Binding<Int>) {
        self.wer = value
    }

    var body: some View {
        ZStack(alignment: .myAlignment) {
            Rectangle()
            .frame(width: self.w[self.selectedIndex], height: height)
            .foregroundColor(Color("SegmentedControlBackground"))
            .alignmentGuide(Alignment.myAlignment.vertical) { d in
                d[VerticalAlignment.center]
            }
            .cornerRadius(height / 2)
            HStack(alignment: Alignment.myAlignment.vertical) {
                ForEach(self.categories.indices, id: \.self) { index in
                    Group {
                        self.createTextView(for: index)
                    }
                }
            }
            .alignmentGuide(Alignment.myAlignment.vertical) { d in d[VerticalAlignment.center] }
        }
        .clipped()
        .cornerRadius(height / 2)
        .overlay(RoundedRectangle(cornerRadius: height / 2, style: .circular).stroke(lineWidth: 1))
    }

    func createTextView(for index: Int) -> some View {
        Group {
            if index == self.selectedIndex {
                Text(categories[index])
                    .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                    .font(.system(size: 12))
                    .foreground(Color.clear.modifier(AnimatableGradient(from: gradient1, to: gradient2, pct: 1)))
                    .foregroundColor(.white)
                    .alignmentGuide(Alignment.myAlignment.horizontal) { d in d[HorizontalAlignment.center] }
                    .background(GeometryReader { geometry in
                        Color.clear
                            .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
                            .preference(key: HeightPreferenceKey.self, value: geometry.size.height)
                    })
                    .onPreferenceChange(WidthPreferenceKey.self, perform: {
                        self.w[index] = $0
                    })
                    .onPreferenceChange(HeightPreferenceKey.self, perform: {
                        self.height = $0
                    })
            } else {
                Text(categories[index])
                    .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                    .font(.system(size: 12))
                    .foreground(Color.clear.modifier(AnimatableGradient(from: gradient1, to: gradient2, pct: 0)))
                    .foregroundColor(Color.black)
                    .background(GeometryReader { geometry in
                        Color.clear
                            .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
                    })
                    .onTapGesture {
                        withAnimation(.easeIn(duration: 0.3)) {
                            self.selectedIndex = index
                        }
                    }
                    .onPreferenceChange(WidthPreferenceKey.self, perform: {
                        self.w[index] = $0
                    })
            }
        }
    }
}

struct SelectedItemPreferencesModifier: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
                .preference(key: HeightPreferenceKey.self, value: geometry.size.height)
        }
    }
}

struct NotSelectedItemPreferencesModifier: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
        }
    }
}


struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue = CGFloat(0)

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        let newValue = nextValue()
        value = newValue
    }

    typealias Value = CGFloat
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue = CGFloat(0)

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        let newValue = nextValue()
        value = newValue
    }

    typealias Value = CGFloat
}


extension VerticalAlignment {
    private enum MyVerticalAlignment : AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d[VerticalAlignment.center]
        }
    }
    
    static let myVerticalAlignment = VerticalAlignment(MyVerticalAlignment.self)
}

private extension HorizontalAlignment {
    private enum MyHorizontalAlignment : AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d[HorizontalAlignment.center]
        }
    }
    
    static let myHorizontalAlignment = HorizontalAlignment(MyHorizontalAlignment.self)
}

private extension Alignment {
    static let myAlignment = Alignment(horizontal: .myHorizontalAlignment, vertical: .myVerticalAlignment)
}

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

extension View {
    func Print(_ vars: Any...) -> some View {
        for v in vars { print(v) }
        return EmptyView()
    }
}

struct SegmentedControllView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            EmptyView()
//            MovieView(movie: MovieDTOFactory.make()).frame(width: 100, height: 250)
        }
    }
}
