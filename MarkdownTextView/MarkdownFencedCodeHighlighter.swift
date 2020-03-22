//
//  MarkdownFencedCodeHighlighter.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/29/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
 Highlights
 ```
 fenced code
 ```
 blocks in Markdown text.
*/
public final class MarkdownFencedCodeHighlighter: RegularExpressionHighlighter {
    
    private static let FencedCodeRegex = regex(pattern: "^(`{3})(?:.*)?$\n[\\s\\S]*\n\\1$")
    
    /**
    Creates a new instance of the receiver.
    
     - Parameter attributes: Attributes to apply to fenced code blocks.
     - Returns: A new instance of the receiver.
    */
    public init(attributes: TextAttributes) {
        super.init(regularExpression: type(of: self).FencedCodeRegex, attributes: attributes)
    }
}
