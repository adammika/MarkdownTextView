//
//  MarkdownListHighlighter.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/29/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
 Highlights Markdown lists using specifiable marker patterns.
*/
public final class MarkdownListHighlighter: HighlighterType {
    
    private let regularExpression: NSRegularExpression
    private let attributes: TextAttributes?
    private let itemAttributes: TextAttributes?
    
    /**
     Creates a new instance of the receiver.
    
     - Parameters:
       - markerPatter: Regular expression pattern to use for matching list markers.
       - attributes: Attributes to apply to the entire list.
       - itemAttributes: Attributes to apply to list items (excluding list markers)
     - Returns: An initialized instance of the receiver.
    */
    public init(markerPattern: String, attributes: TextAttributes?, itemAttributes: TextAttributes?) {
        self.regularExpression = listItemRegex(pattern: markerPattern)
        self.attributes = attributes
        self.itemAttributes = itemAttributes
    }
    
    // MARK: - HighlighterType
    
    public func highlight(attributedString: NSMutableAttributedString) {
        if (attributes == nil && itemAttributes == nil) { return }
        
        enumerateMatches(regex: regularExpression, string: attributedString.string) {
            if let attributes = self.attributes {
                attributedString.addAttributes(attributes, range: $0.range)
            }
            if let itemAttributes = self.itemAttributes {
                attributedString.addAttributes(itemAttributes, range: $0.range(at:1))
            }
        }
    }
}

private func listItemRegex(pattern: String) -> NSRegularExpression {
    // From markdown.pl v1.0.1 <http://daringfireball.net/projects/markdown/>
    return regex(pattern:"^(?:[ ]{0,3}(?:\(pattern))[ \t]+)(.*)")
}
