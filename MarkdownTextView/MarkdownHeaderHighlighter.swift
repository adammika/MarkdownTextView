//
//  MarkdownHeaderHighlighter.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/29/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
*  Highlights atx-style Markdown headers.
*/
public final class MarkdownHeaderHighlighter: HighlighterType {
    
    // From markdown.pl v1.0.1 <http://daringfireball.net/projects/markdown/>
    private static let HeaderRegex = regex(pattern: "^(\\#{1,6})[ \t]+(?:.+?)*.*")
    private let attributes: MarkdownAttributes.HeaderAttributes
    
    /**
    Creates a new instance of the receiver.
    
     - Parameter attributes: Attributes to apply to Markdown headers.
     - Returns: An initialized instance of the receiver.
    */
    public init(attributes: MarkdownAttributes.HeaderAttributes) {
        self.attributes = attributes
    }
    
    // MARK: - HighlighterType
    
    public func highlight(attributedString: NSMutableAttributedString) {
        enumerateMatches(regex: type(of: self).HeaderRegex, string: attributedString.string) {
            let level = $0.range(at: 1).length
            if let attributes = self.attributes.attributes(headerLevel: level) {
                attributedString.addAttributes(attributes, range: $0.range)
            }
        }
    }
}
