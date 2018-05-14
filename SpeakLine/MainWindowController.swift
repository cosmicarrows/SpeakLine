//
//  MainWindowController.swift
//  SpeakLine
//
//  Created by Cosmic Arrows, LLC on 5/5/18.
//  Copyright © 2018 Cosmic Arrows, LLC. All rights reserved.
//

import Cocoa
import CoreFoundation



class MainWindowController: NSWindowController, NSSpeechSynthesizerDelegate, NSWindowDelegate, NSTableViewDataSource, NSTableViewDelegate {
    //Now MainWindowController is more powerful by having its own KITT being able to delegate powerful functionality and do less work.  The delegate will do all the heavy lifting and return the results to MainWindowController instances.
    // MARK: - Properties
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var speakButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    
    let speechSynth = NSSpeechSynthesizer.init(voice: NSSpeechSynthesizer.VoiceName.init(rawValue: "com.apple.speech.synthesis.voice.Victoria"))
    
    
    var isSpeaking: Bool = false {
        didSet {
            updateButtons()
        }
    }
    
    
    let voices = NSSpeechSynthesizer.availableVoices as [NSString]
    
    // MARK: - NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return voices.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let voice = voices[row]
        let voiceName = voiceNameForIdentifier(identifier: voice as String)
        return voiceName
        
    }
    
    //MARK: - NSTableViewDelegate
    func tableViewSelectionDidChange(_ notification: Notification) {
        
        let row = tableView.selectedRow
        
        //Set the voice back to the default if the user has deselected all rows
        if row == -1 {
            speechSynth?.setVoice(nil)
            return
        }
        
        let voice = voices[row]
        
        speechSynth?.setVoice(NSSpeechSynthesizer.VoiceName(rawValue: NSSpeechSynthesizer.VoiceName.RawValue(voice)))
    }
    
    
    // MARK: - Overriden Properties
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("MainWindowController")
    }
    // MARK: - Overidden Methods
    override func windowDidLoad() {
        super.windowDidLoad()
        
        updateButtons()
        
        speechSynth?.delegate = self
        
        window?.delegate = self
        
        let voices = NSSpeechSynthesizer.availableVoices.map { $0.rawValue }
        
        for voice in voices {
            
            print(voiceNameForIdentifier(identifier: voice)!)
        }
        
        let defaultVoice = NSSpeechSynthesizer.defaultVoice
        
        if let defaultRow = voices.index(of: defaultVoice.rawValue) {
            
            let indices = NSIndexSet(index: defaultRow)
            tableView.selectRowIndexes(indices as IndexSet, byExtendingSelection: false)
            tableView.scrollRowToVisible(defaultRow)
        }
       
    }
    
    // MARK: - UI methods
    @IBAction func speakIt(sender: NSButton) {
        //Get tuype-in text as a string
        let string = textField.stringValue
        if string.isEmpty {
            print("string from \(textField) is empty")
        } else {
            speechSynth?.startSpeaking(string)
            isSpeaking = true
        }
    }
    
    @IBAction func stopIt(sender: NSButton) {
        speechSynth?.stopSpeaking()
    }
    
    func updateButtons(){
        if isSpeaking {
            speakButton.isEnabled = false
            stopButton.isEnabled = true
        } else {
            speakButton.isEnabled = true
            stopButton.isEnabled = false
        }
    }
    
    // MARK: - NSSpeechSynthesizerDelegate Methods
    //this functionality is considered more powerful and is made possible due to the speechSynthesizer.delegate = self
    //the delegate is doing the work and reporting that completed work to the MainWindowController instance
    //so kinda like the delegate is providing the signature and its up to us as the developers based on what we do with those parameters inside the function in order  for us to add our own creativity.
    func speechSynthesizer(_ sender: NSSpeechSynthesizer, didFinishSpeaking finishedSpeaking: Bool) {
        //by setting this variable to FALSE, it will fire off the didSet computed property which this variable has both storage and behavior.
        isSpeaking = false
        let siriKeys = "Siri where are my keys?"
        if textField.stringValue == siriKeys {
            print("Your keys are waiting for you downstairs in the foyer")
        }
        
    }
    
    // MARK: - NSWindowDelegate Methods
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        if isSpeaking == false {
            return true
        } else {
            print("You can't close me!")
            return false
        }
    }
    
    //Now we're creating a custom function that we will call...
    func voiceNameForIdentifier(identifier: String) -> String? {
        //class method below....we're going to use this function and pass in the string to the function which needs to be a backwards domain assigned to a voice
        //it returns a dictionary of the following type [NSSpeechSynthesizer.VoiceAttributeKey : Any]...so it'll be names for the key and the values consist of the backward domain strings
        let attributes = NSSpeechSynthesizer.attributes(forVoice: NSSpeechSynthesizer.VoiceName.init(rawValue: identifier))
        //here below, we will return the needed string that the function asks for....it is the declared constant
        return attributes[NSSpeechSynthesizer.VoiceAttributeKey.name] as? String
    }
}
