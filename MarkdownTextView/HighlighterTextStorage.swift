//
//  RegularExpressionTextStorage.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

/**
 Text storage with support for automatically highlighting text
 as it changes.
*/
public class HighlighterTextStorage: NSTextStorage {
    
    private let backingStore: NSMutableAttributedString
    private var highlighters = [HighlighterType]()
    
    /// Default attributes to use for styling text.
    public var defaultAttributes: TextAttributes = [
        .font: UIFont.preferredFont(forTextStyle: .body)
    ] {
        didSet { editedAll(actions: .editedAttributes) }
    }
    
    // MARK: - API
    
    /**
     Adds a highlighter to use for highlighting text.
    
     Highlighters are invoked in the order in which they are added.
    
     - Parameter highlighter: The highlighter to add.
    */
    public func add(highlighter: HighlighterType) {
        highlighters.append(highlighter)
        editedAll(actions: .editedAttributes)
    }
    
    // MARK: - Initialization
    
    public override init() {
        backingStore = NSMutableAttributedString(string: "", attributes: defaultAttributes)
        super.init()
    }

    required public init?(coder aDecoder: NSCoder) {
        backingStore = NSMutableAttributedString(string: "", attributes: defaultAttributes)
        super.init(coder: aDecoder)
    }
    
    // MARK: - NSTextStorage
    
    public override var string: String {
        return backingStore.string
    }
    
    public override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> TextAttributes {
        return backingStore.attributes(at: location, effectiveRange: range)
    }
    
    public override func replaceCharacters(in range: NSRange, with attrString: NSAttributedString) {
        backingStore.replaceCharacters(in: range, with: attrString)
        edited(.editedCharacters, range: range, changeInLength: attrString.length - range.length)
    }
    
    public override func setAttributes(_ attrs: TextAttributes?, range: NSRange) {
        backingStore.setAttributes(attrs, range: range)
        edited(.editedAttributes, range: range, changeInLength: 0)
    }
    
    public override func processEditing() {
        /**
            This is inefficient but necessary because certain
            edits can cause formatting changes that span beyond
            line or paragraph boundaries. This should be alright
            for small amounts of text (which is the use case that
            this was designed for), but would need to be optimized
            for any kind of heavy editing.
        */
        highlight(range: NSRange(location: 0, length: backingStore.length))
        super.processEditing()
    }
    
    private func editedAll(actions: EditActions) {
        edited(actions, range: NSRange(location: 0, length: backingStore.length), changeInLength: 0)
    }
    
    private func highlight(range: NSRange) {
        backingStore.beginEditing()
        setAttributes(defaultAttributes, range: range)
        let attrString = backingStore.attributedSubstring(from: range).mutableCopy() as! NSMutableAttributedString
        for highlighter in highlighters {
            highlighter.highlight(attributedString: attrString)
        }
        replaceCharacters(in: range, with: attrString)
        backingStore.endEditing()
    }
}
