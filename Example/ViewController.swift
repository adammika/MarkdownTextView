//
//  ViewController.swift
//  MarkdownTextView
//
//  Created by Indragie on 4/27/15.
//  Copyright (c) 2015 Indragie Karunaratne. All rights reserved.
//

import UIKit
import MarkdownTextView

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let attributes = MarkdownAttributes()
        let textStorage = MarkdownTextStorage(attributes: attributes)
        do {
            textStorage.add(highlighter:try LinkHighlighter())
        } catch let error {
            fatalError("Error initializing LinkHighlighter: \(error)")
        }
        textStorage.add(highlighter:MarkdownStrikethroughHighlighter())
        textStorage.add(highlighter:MarkdownSuperscriptHighlighter())
        if let codeBlockAttributes = attributes.codeBlockAttributes {
            textStorage.add(highlighter:MarkdownFencedCodeHighlighter(attributes: codeBlockAttributes))
        }
        
        let textView = MarkdownTextView(frame: .zero, textStorage: textStorage)
        textView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textView)
        
        let views = ["textView": textView]
        var constraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[textView]-20-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[textView]-20-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views)
        NSLayoutConstraint.activate(constraints)
    }
}
