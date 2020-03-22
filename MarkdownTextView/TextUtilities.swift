//
//  TextUtilities.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/28/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit

public typealias TextAttributes = [NSAttributedString.Key: Any]

internal func font(traits: UIFontDescriptor.SymbolicTraits, font: UIFont) -> UIFont {
    let combinedTraits = UIFontDescriptor.SymbolicTraits(rawValue: font.fontDescriptor.symbolicTraits.rawValue | (traits.rawValue & 0xFFFF))
    
    guard let descriptor = font.fontDescriptor.withSymbolicTraits(combinedTraits) else {
        fatalError("Error constructing font descriptor with traits: \(combinedTraits)")
    }
    return UIFont(descriptor: descriptor, size: font.pointSize)
}

internal func regex(pattern: String) -> NSRegularExpression {
    do {
        return try NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
    } catch let error {
        fatalError("Error constructing regular expression: \(error)")
    }
}

internal func enumerateMatches(regex: NSRegularExpression, string: String, block: (NSTextCheckingResult) -> Void) {
    let range = NSRange(location: 0, length: (string as NSString).length)
    regex.enumerateMatches(in: string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: range) { (result, _, _) in
        if let result = result {
            block(result)
        }
    }
}
