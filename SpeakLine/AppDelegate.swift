//
//  AppDelegate.swift
//  SpeakLine
//
//  Created by Cosmic Arrows, LLC on 5/5/18.
//  Copyright © 2018 Cosmic Arrows, LLC. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var mainWindowController: MainWindowController?
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        //create a window controller
        let mainWindowController = MainWindowController()
        
        
        
        //put the window of the window controller on screen
        mainWindowController.showWindow(self)
        
        //set the property to point to the window controller
        self.mainWindowController = mainWindowController
    }

}

