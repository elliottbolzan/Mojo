//
//  AppDelegate.swift
//  Mojo
//
//  Created by Elliott Bolzan on 11/17/15.
//  Copyright © 2015 Elliott Bolzan. All rights reserved.
//

import Cocoa

var nameData: NSDictionary?
var favorites = [String: Int]()
var appearance = ""
let popover = NSPopover()
var content = [String]()
var searchOutput = [String]()

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-2)
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(notification: NSNotification) {

        // Setup Button

        if let button = statusItem.button {
            button.image = NSImage(named: "StatusBarButtonImage")
            button.action = Selector("togglePopover:")
        }

        // Set Appearance

        appearance = NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") ?? "Light"

        popover.animates = false
        popover.contentViewController = MojoViewController(nibName: "MojoViewController", bundle: nil)

        // Load Names and Counts

        nameData = NSDictionary(contentsOfFile: NSBundle.mainBundle().pathForResource("Keywords", ofType: "plist")!)

        // Monitor Clicks

        eventMonitor = EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask]) { [unowned self] event in
            if popover.shown {
                self.closePopover(event)
            }
        }
        eventMonitor?.start()
    }

    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: NSRectEdge.MinY)
        }
        eventMonitor?.start()
    }

    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }

    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

