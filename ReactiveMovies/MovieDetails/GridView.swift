//
//  GridView.swift
//  ReactiveMovies
//
//  Created by Maciej Krolikowski on 15/05/2020.
//  Copyright © 2020 Maciej Krolikowski. All rights reserved.
//

import SwiftUI

struct BoundsPreferenceKey: PreferenceKey {
    public static var defaultValue: [CGRect] = []
    
    public static func reduce(value: inout [CGRect], nextValue: () -> [CGRect]) {
        value.append(contentsOf: nextValue())
    }
}

struct GridPreferencesKey: PreferenceKey {
    public static var defaultValue: GridPreferences = GridPreferences(items: [], size: .zero)
    
    public static func reduce(value: inout GridPreferences, nextValue: () -> GridPreferences) {
//        defaultValue.merge(with: value)
        value.merge(with: nextValue())
    }
}

struct GridConfig {
    var height: CGFloat = 120
    var minWidth: CGFloat = 150
    var vSpacing: CGFloat = 100
    var hSpacing: CGFloat = 30
    
    func transformGridPreferences(preference: inout GridPreferences, size: CGSize) {
        var numberOfItemsInRow = floor(size.width / minWidth)
        if numberOfItemsInRow == 0 {
            numberOfItemsInRow = 1
        }
        numberOfItemsInRow = floor((size.width - (numberOfItemsInRow - 1) * hSpacing) / minWidth)
        let itemWidth = (size.width - (numberOfItemsInRow - CGFloat(1)) * hSpacing) / numberOfItemsInRow
        var newPreferences: GridPreferences = GridPreferences(items: [])
        
        preference.items.enumerated().forEach { index, item in
            let positionInRow: Int
            
            if numberOfItemsInRow == 0 {
                numberOfItemsInRow = 1
            }

            positionInRow = index % Int(numberOfItemsInRow)
//            let positionInRow = index
            
            let row: Int = Int(ceil(CGFloat(index + 1) / CGFloat(numberOfItemsInRow)))
            
            let x = CGFloat(positionInRow) * itemWidth + ((CGFloat(positionInRow - 1)) * hSpacing)
            
            let y =  CGFloat(row - 1) * height + ((CGFloat(row - 1)) * vSpacing)

            newPreferences.merge(
                with: GridPreferences(
                    items: [GridPreferences.Item(id: item.id, bounds: CGRect(origin: CGPoint(x: x, y: y), size: CGSize(width: itemWidth, height: height)))],
                    size: size
                )
            )
        }
        preference = newPreferences
    }
}

struct GridView: View {
//struct GridView<Content>: View where Content: View {
    
    var gridItems: [GridItemm] = [
        GridItemm(title: "1"),
        GridItemm(title: "2"),
        GridItemm(title: "3"),
        GridItemm(title: "4"),
        GridItemm(title: "5"),
        GridItemm(title: "6"),
        GridItemm(title: "7")
    ]
    
    @State var preferences: GridPreferences = GridPreferences(items: [], size: .zero)
    
    var config = GridConfig()
    
    var body: some View {
        GeometryReader { reader in
            ZStack(alignment: .topLeading) {
                ForEach(self.gridItems) { item in
                    item.frame(
                        width: self.preferences[item.id]?.bounds.width, //100,
                        height: self.preferences[item.id]?.bounds.height //100
                    )
                    .alignmentGuide(.leading) { _ -> CGFloat in
//                        reader.size.width - CGFloat(100 * Int(item.id)!)
                        let value = reader.size.width - (self.preferences[item.id]?.bounds.origin.x ?? 0)
//                        let value = self.preferences[item.id]?.bounds.origin.x ?? 0
                        print("x value: \(value)")
                        return value
                    }
                    .alignmentGuide(.top, computeValue: { _ in
                        reader.size.height - (self.preferences[item.id]?.bounds.origin.y ?? 0)
                    })
//                    .background(GridPreferencesModifier(id: item.id, bounds: self.preferences[item.id]?.bounds ?? .zero))
                    .background(GridPreferencesModifier(id: item.id, bounds: self.preferences[item.id]?.bounds ?? .zero))
                }
            }
            .transformPreference(GridPreferencesKey.self) { gridPreferences in
                self.config.transformGridPreferences(preference: &gridPreferences, size: reader.size)
            }
        }
        .frame(
            minWidth: self.preferences.size.width,
            minHeight: nil,
            alignment: .topLeading
        )
        .onPreferenceChange(GridPreferencesKey.self) { preferences in
            self.preferences = preferences
        }
    }
    
//    private func transformGridPreferences(preference: inout GridPreferences) {}
}

struct GridView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .trailing) {
//            GridView(0...100, id: \.self) {
//                Text("\($0)")
//            }
            ScrollView(.vertical) {
                GridView()
            }
//            Text("wer")
        }
    }
}

//extension GridView {
//    public init<Data, Item>(_ data: Data, @ViewBuilder item: @escaping (Data.Element) -> Item) where Content == ForEach<Data, Data.Element.ID, Item>, Data : RandomAccessCollection, Item : View, Data.Element : Identifiable {
//        self.gridItems = data.map { GridItemm(view: AnyView(item($0)), id: AnyHashable($0.id)) }
//    }
//
//    public init<Data, ID, Item>(_ data: Data, id: KeyPath<Data.Element, ID>, @ViewBuilder item: @escaping (Data.Element) -> Item) where Content == ForEach<Data, ID, Item>, Data : RandomAccessCollection, ID : Hashable, Item : View {
//        self.gridItems = data.map { GridItemm(view: AnyView(item($0)), id: AnyHashable($0[keyPath: id])) }
//    }
//
//    public init<Item>(_ data: Range<Int>, @ViewBuilder item: @escaping (Int) -> Item) where Content == ForEach<Range<Int>, Int, Item>, Item : View {
//        self.gridItems = data.map { GridItemm(view: AnyView(item($0)), id: AnyHashable($0)) }
//    }
//}

//struct GridItem: Identifiable {
//    let view: AnyView
//    let id: AnyHashable
//}

//struct GridPreferencesModifier: View {
//
//    let id: String
//    let bounds: CGRect
//
//    var body: some View {
//        GeometryReader { reader in
//            Color.clear
//                .preference(
//                    key: GridPreferencesKey.self,
//                    value: GridPreferences(
//                        items: [GridPreferences.Item(id: self.id, bounds: CGRect(origin: self.bounds.origin, size: reader.size))]
//                    )
//                )
//        }
//    }
//}

struct GridPreferencesModifier: View {
    let id: AnyHashable
    let bounds: CGRect
    
    var body: some View {
        GeometryReader { geometry in
            self.Print(self.id)
            Color
                .clear
                .preference(key: GridPreferencesKey.self, value:
                    GridPreferences(items: [
                        GridPreferences.Item(id: self.id, bounds: CGRect(origin: self.bounds.origin, size: geometry.size))
                    ])
                )
        }
    }
}

struct GridPreferences: Equatable {

    struct Item: Equatable {
        var id: AnyHashable
        var bounds: CGRect
    }
    
    var items: [Item]
    
    var size: CGSize
    
    subscript(id: AnyHashable) -> Item? {
        get {
            return items.first(where: { $0.id == id })
        }
    }
    
    init(items: [Item], size: CGSize = .zero) {
        self.items = items
        self.size = size
    }
    
    mutating func merge(with preferences: GridPreferences) {
        self.items.append(contentsOf: preferences.items)
        self.size = CGSize(
            width: self.items.map { $0.bounds.origin.x + $0.bounds.size.width }.max() ?? 0,
            height: self.items.map { $0.bounds.origin.y + $0.bounds.size.height }.max() ?? 0
        )
        print(size)
    }
}

struct GridStyle {
    var itemMaxWidth: CGFloat
    var itemMinWidth: CGFloat
    
    var verticalSpacing: CGFloat
    var horizontalSpacing: CGFloat
    
    
}

struct GridItemm: View, Identifiable {
    var id: String {
        return title
    }
    
    var title: String
    
    var body: some View {
//        ZStack {
//            Text(title)
//                .foregroundColor(.blue)
//        }.background(
//            Rectangle().foregroundColor(.red)
//        )
        Rectangle().foregroundColor(.red)
    }
}
