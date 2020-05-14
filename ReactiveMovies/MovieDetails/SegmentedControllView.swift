//
//  SegmentedControllView.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 03/05/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue = CGFloat(0)

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }

    typealias Value = CGFloat
}

struct HeightPreferenceKey: PreferenceKey {
    static var defaultValue = CGFloat(0)

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
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

extension HorizontalAlignment {
    private enum MyHorizontalAlignment : AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            return d[HorizontalAlignment.center]
        }
    }
    
    static let myHorizontalAlignment = HorizontalAlignment(MyHorizontalAlignment.self)
}

extension Alignment {
    static let myAlignment = Alignment(horizontal: .myHorizontalAlignment, vertical: .myVerticalAlignment)
}


struct SegmentedControllView: View {
    
    @State private var selectedIndex: Int = 0
    
    @State private var w: [CGFloat] = [0, 0, 0, 0]
    
    @State private var height: CGFloat = 0
    
    let categories: [String] = ["Streaming", "On TV", "For Rent", "In theaters"]

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
            .transition(AnyTransition.identity)
            .alignmentGuide(Alignment.myAlignment.vertical) { d in d[VerticalAlignment.center] }
        }
        .clipped()
        .cornerRadius(height / 2)
        .overlay(RoundedRectangle(cornerRadius: height / 2, style: .circular).stroke(lineWidth: 1))
    }
    
    func createTextView(for index: Int) -> some View {
        Group {
            if index == self.selectedIndex {
                Text(self.categories[index])
                    .foregroundColor(.white)
                    .transition(AnyTransition.identity)
                    .alignmentGuide(Alignment.myAlignment.horizontal) { d in d[HorizontalAlignment.center]
                    }
                    .padding()
                    .font(.system(size: 10))
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
                Text(self.categories[index])
                    .foregroundColor(Color.black)
                    .transition(AnyTransition.identity)
                    .padding()
                    .font(.system(size: 10))
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
    
    func makeGradient() -> some View {
        LinearGradient(
            gradient: .init(colors: [Color("SegmentedControlGradientStart"), Color("SegmentedControlGradientEnd")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
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
        SegmentedControllView()
//        GradientText()
    }
}
