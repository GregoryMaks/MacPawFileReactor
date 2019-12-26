//
//  AppDelegate.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/21/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - Lifecycle
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }
    
    // MARK: - Configuration
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
}
 
