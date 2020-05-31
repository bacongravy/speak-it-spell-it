//
//  HighlightableText.swift
//  Speak It Spell It
//
//  Created by David Kramer on 5/30/20.
//  Copyright © 2020 David Kramer. All rights reserved.
//

import SwiftUI

struct HighlightableText: View {
    var string: String
    var placeholder: String
    @Binding var indexOfHighlightedLetter: Int
    @Binding var shouldHighlight: Bool
    var weight: Font.Weight? = nil

    var body: some View {
        var i: Int = -1
        return (
            string.isEmpty
                ? Text(placeholder).foregroundColor(.gray)
                : string
                    .map {
                        i += 1
                        let highlight = shouldHighlight
                            && (self.indexOfHighlightedLetter == -1 || self.indexOfHighlightedLetter == i)
                        return Text(String.init($0)).foregroundColor(highlight ? .red : .primary)
                    }
                    .reduce(Text(""), +)
            )
            .fontWeight(self.weight)
    }
}

extension HighlightableText {
    func fontWeight(_ weight: Font.Weight?) -> HighlightableText {
        var copy = self
        copy.weight = weight
        return copy
    }
}

struct HighlightableText_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HighlightableText(string: "",
                              placeholder: "bar",
                              indexOfHighlightedLetter: .constant(1),
                              shouldHighlight: .constant(false))
            HighlightableText(string: "foo",
                              placeholder: "bar",
                              indexOfHighlightedLetter: .constant(1),
                              shouldHighlight: .constant(false))
            HighlightableText(string: "foo",
                              placeholder: "bar",
                              indexOfHighlightedLetter: .constant(-1),
                              shouldHighlight: .constant(true))
            HighlightableText(string: "foo",
                              placeholder: "bar",
                              indexOfHighlightedLetter: .constant(1),
                              shouldHighlight: .constant(true))
        }
    }
}
