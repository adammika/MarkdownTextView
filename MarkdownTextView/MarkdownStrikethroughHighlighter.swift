//
//  MarkdownStrikethroughHighlighter.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/29/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
*  Highlights ~~strikethrough~~ in Markdown text (unofficial extension)
*/
public final class MarkdownStrikethroughHighlighter: HighlighterType {
    private static let StrikethroughRegex = regex(pattern: "(~~)(?=\\S)(.+?)(?<=\\S)\\1")
    private let attributes: TextAttributes?
    
    /**
    Creates a new instance of the receiver.
    
    :param: attributes Optional additional attributes to apply
    to strikethrough text.
    
    :returns: An initialized instance of the receiver.
    */
    public init(attributes: TextAttributes? = nil) {
        self.attributes = attributes
    }
    
    // MARK: HighlighterType
    
    public func highlight(attributedString: NSMutableAttributedString) {
        enumerateMatches(regex: type(of: self).StrikethroughRegex, string: attributedString.string) {
            var strikethroughAttributes: TextAttributes = [
            .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]
            if let attributes = self.attributes {
                for (key, value) in attributes {
                    strikethroughAttributes[key] = value
                }
            }
            attributedString.addAttributes(strikethroughAttributes, range: $0.range(at: 2))
        }
    }
}
