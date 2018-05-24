//
//  ViewController.swift
//  CustomFontPlistCreator
//
//  Created by Rico Crescenzio on 13/12/17.
//  Copyright © 2017 wink srl. All rights reserved.
//

import AppKit

class CustomFontPlistViewController: NSViewController {
    
    @IBOutlet private weak var codeTextField: NSTextView!
    
    let panel = NSOpenPanel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func selectFontFilesDidTap(_ sender: Any) {
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.begin() { response in
            if response == .OK {
                self.updateResult()
            }
        }
    }
    
    private func updateResult() {
        guard !panel.urls.isEmpty else {
            codeTextField.string = ""
            return
        }
        
        let violetColor = NSColor(calibratedRed: 178, green: 24, blue: 137, alpha: 1)
        let keywordAttributes: [NSAttributedStringKey : Any] = [.foregroundColor : violetColor, .font : NSFont.systemFont(ofSize: 16, weight: .regular)]
        let newLine = NSAttributedString(string: "\n")
        let tab = NSAttributedString(string: "\t")
        let key = NSAttributedString(string: "<key>", attributes: keywordAttributes)
        let closeKey = NSAttributedString(string: "</key>", attributes: keywordAttributes)
        let array = NSAttributedString(string: "<array>", attributes: keywordAttributes)
        let closeArray = NSAttributedString(string: "</array>", attributes: keywordAttributes)
        let string = NSAttributedString(string: "<string>", attributes: keywordAttributes)
        let closeString = NSAttributedString(string: "</string>", attributes: keywordAttributes)
        
        let finalText = NSMutableAttributedString()
        finalText.append(key)
        finalText.append(NSAttributedString(string: "UIAppFonts"))
        finalText.append(closeKey)
        finalText.append(newLine)
        finalText.append(array)
        finalText.append(newLine)
        
        panel.urls.forEach { url in
            finalText.append(tab)
            finalText.append(string)
            finalText.append(NSAttributedString(string: url.lastPathComponent))
            finalText.append(closeString)
            finalText.append(newLine)
        }
        
        finalText.append(closeArray)
        codeTextField.string = finalText.string
        
    }
    
}

