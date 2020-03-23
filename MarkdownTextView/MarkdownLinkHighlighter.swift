//
//  MarkdownLinkHighlighter.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/29/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
 Highlights Markdown links (not including link references)
*/
public final class MarkdownLinkHighlighter: HighlighterType {
    
    // From markdown.pl v1.0.1 <http://daringfireball.net/projects/markdown/>
    private static let LinkRegex = regex(pattern:"\\[([^\\[]+)\\]\\([ \t]*<?(.*?)>?[ \t]*((['\"])(.*?)\\4)?\\)")
    
    // MARK: - HighlighterType
    
    public func highlight(attributedString: NSMutableAttributedString) {
        let string = attributedString.string
        enumerateMatches(regex: type(of: self).LinkRegex, string: string) {
            guard let range = Range($0.range(at: 2)),
                let url = url(string[range]) else { return }
            
            let linkAttributes: TextAttributes = [
                .link: url
            ]
            attributedString.addAttributes(linkAttributes, range: $0.range)
        }
    }
    
    private func url(_ urlString: String) -> String? {
        var url = URL(string: urlString)
        
        if url?.scheme == nil {
            url = URL(string: "http://\(urlString)")
        }
        
        return url?.absoluteString
    }
}
