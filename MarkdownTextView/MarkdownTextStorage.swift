//
//  MarkdownTextStorage.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
 Text storage with support for highlighting Markdown.
*/
public class MarkdownTextStorage: HighlighterTextStorage {
    
    private let attributes: MarkdownAttributes
    
    // MARK: - Initialization
    
    /**
     Creates a new instance of the receiver.
    
     - Parameter attributes: Attributes used to style the text.
     - Returns: An initialized instance of the receiver.
    */
    public init(attributes: MarkdownAttributes = MarkdownAttributes()) {
        self.attributes = attributes
        super.init()
        commonInit()
        
        if let headerAttributes = attributes.headerAttributes {
            add(highlighter: MarkdownHeaderHighlighter(attributes: headerAttributes))
        }
        
        add(highlighter: MarkdownLinkHighlighter())
        add(highlighter: MarkdownListHighlighter(markerPattern: "[*+-]", attributes: attributes.unorderedListAttributes, itemAttributes: attributes.unorderedListItemAttributes))
        add(highlighter: MarkdownListHighlighter(markerPattern: "\\d+[.]", attributes: attributes.orderedListAttributes, itemAttributes: attributes.orderedListItemAttributes))
        
        // From markdown.pl v1.0.1 <http://daringfireball.net/projects/markdown/>
        
        // Code blocks
        addPattern("(?:\n\n|\\A)((?:(?:[ ]{4}|\t).*\n+)+)((?=^[ ]{0,4}\\S)|\\Z)", attributes.codeBlockAttributes)
        
        // Block quotes
        addPattern("(?:^[ \t]*>[ \t]?.+\n(.+\n)*\n*)+", attributes.blockQuoteAttributes)
        
        // Se-text style headers
        // H1
        addPattern("^(?:.+)[ \t]*\n=+[ \t]*\n+", attributes.headerAttributes?.h1Attributes)
        
        // H2
        addPattern("^(?:.+)[ \t]*\n-+[ \t]*\n+", attributes.headerAttributes?.h2Attributes)
        
        // Emphasis
        addPattern("(\\*|_)(?=\\S)(.+?)(?<=\\S)\\1", self.attributes(traits: .traitItalic, attributes.emphasisAttributes))
        
        // Strong
        addPattern("(\\*\\*|__)(?=\\S)(?:.+?[*_]*)(?<=\\S)\\1", self.attributes(traits: .traitBold, attributes.strongAttributes))
        
        // Inline code
        addPattern("(`+)(?:.+?)(?<!`)\\1(?!`)", attributes.inlineCodeAttributes)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        attributes = MarkdownAttributes()
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        defaultAttributes = attributes.defaultAttributes
    }
    
    // MARK: - Helpers
    
    private func addPattern(_ pattern: String, _ attributes: TextAttributes?) {
        if let attributes = attributes {
            let highlighter = RegularExpressionHighlighter(regularExpression: regex(pattern: pattern), attributes: attributes)
            add(highlighter:highlighter)
        }
    }
    
    private func attributes(traits: UIFontDescriptor.SymbolicTraits, _ attributes: TextAttributes?) -> TextAttributes? {
        var attributes = attributes
        if let defaultFont = defaultAttributes[.font] as? UIFont, attributes == nil {
            attributes = [
                .font: font(traits: traits, font: defaultFont)
            ]
        }
        return attributes
    }
}
