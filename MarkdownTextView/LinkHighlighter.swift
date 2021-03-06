//
//  LinkHighlighter.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/29/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
 Highlights URLs.
*/
public final class LinkHighlighter: HighlighterType {
    
    private var detector: NSDataDetector!
    
    public init() throws {
        detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
    }
    
    // MARK: - HighlighterType
    
    public func highlight(attributedString: NSMutableAttributedString) {
        enumerateMatches(regex: detector, string: attributedString.string) {
            if let URL = $0.url {
                let linkAttributes: TextAttributes = [
                    .link: URL
                ]
                attributedString.addAttributes(linkAttributes, range: $0.range)
            }
        }
    }
}
