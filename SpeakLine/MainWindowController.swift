//
//  MainWindowController.swift
//  SpeakLine
//
//  Created by Cosmic Arrows, LLC on 5/5/18.
//  Copyright © 2018 Cosmic Arrows, LLC. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var speakButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("MainWindowController")
    }

    override func windowDidLoad() {
        super.windowDidLoad()

    }
    
    // MARK: - Action methods
    @IBAction func speakIt(sender: NSButton) {
        
        //Get tuype-in text as a strin
        let string = textField.stringValue
        if string.isEmpty {
            print("string from \(textField) is empty")
        } else {
            print("string is \"\(textField.stringValue)\"")
        }
    }
    
    @IBAction func stopIt(sender: NSButton) {
        print("stop button clicked")
    }
}
