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
    
    let categories: [String] = ["Streaming", "On TV", "For Rent", "In theaters"]

    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .myAlignment) {
                HStack(alignment: Alignment.myAlignment.vertical) {
                    ForEach(self.categories.indices, id: \.self) { index in
                        Group {
                            if index == self.selectedIndex {
                                Text(self.categories[index])
                                    .transition(AnyTransition.identity)
                                    .alignmentGuide(Alignment.myAlignment.horizontal) { d in d[HorizontalAlignment.center]
                                    }
                                    .padding()
                                    .font(.system(size: 10))
                                    .background(GeometryReader { geometry in
                                        Color.clear.preference(key: WidthPreferenceKey.self, value: geometry.size.width)
                                    })
                                    .onPreferenceChange(WidthPreferenceKey.self, perform: {
                                        self.w[index] = $0
                                    })
                                
                            } else {
                                Text(self.categories[index])
                                    .transition(AnyTransition.identity)
                                    .onTapGesture {
                                        withAnimation {
                                            self.selectedIndex = index
                                        }
                                    }
                                    .onPreferenceChange(WidthPreferenceKey.self, perform: {
                                        self.w[index] = $0
                                    })
                                    .padding()
                                    .font(.system(size: 10))
                            }
                        }
                    }
                }
                .transition(AnyTransition.identity)
                .alignmentGuide(Alignment.myAlignment.vertical) { d in d[VerticalAlignment.center] }
                Rectangle()
                    .frame(width: self.w[self.selectedIndex], height: 40)
                    .background(Color.black).opacity(0.1)
                    .alignmentGuide(Alignment.myAlignment.vertical) { d in
                        d[VerticalAlignment.center]
                    }
            }
            .clipped()
            .overlay(RoundedRectangle(cornerRadius: reader.size.height / 2, style: .circular).stroke(lineWidth: 1))
        }
    }
}

struct SegmentedControllView_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedControllView()
    }
}
