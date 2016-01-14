//
//  MojoViewController.swift
//  Mojo
//
//  Created by Elliott Bolzan on 11/17/15.
//  Copyright © 2015 Elliott Bolzan. All rights reserved.
//

import Cocoa
import QuartzCore
import ServiceManagement

protocol ClickedEmojiDelegate {
    func emojiWasClicked()
}

class MojoViewController: NSViewController, ClickedEmojiDelegate, NSCollectionViewDataSource {

    @IBOutlet var searchField: NSSearchField!
    @IBOutlet var collectionView: NSCollectionView?
    @IBOutlet var scrollView: NSScrollView?
    @IBOutlet var noResults: NSTextField?
    @IBOutlet var instructions: NSTextField?

    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    let displayConstant = 48

    var queue = NSOperationQueue()

    var clickedTimer = NSTimer()

    let settingsMenu = NSMenu()

    // Important Setup

    override func viewDidLoad() {
        super.viewDidLoad()

        darkMode()

        // Instructions

        instructions!.drawsBackground = true
        instructions!.backgroundColor = NSColor.clearColor()

        // No Results

        noResults!.bezeled = false
        noResults!.editable = false
        noResults!.bordered = false
        noResults!.hidden = true
        noResults!.drawsBackground = true
        noResults!.backgroundColor = NSColor.clearColor()

        // Search Field

        searchField.focusRingType = .None
        (searchField.cell as! NSSearchFieldCell).cancelButtonCell!.action = "clearSearch"
        (searchField.cell as! NSSearchFieldCell).cancelButtonCell!.target = self

        // Clear Defaults

        /*for key in NSUserDefaults.standardUserDefaults().dictionaryRepresentation().keys {
            NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        }*/

        // Settings

        let toggleItem = NSMenuItem()
        toggleItem.title = "Launch at Login"
        toggleItem.action = "toggleLaunch:"

        if defaults.objectForKey("launchLogin") == nil {
            defaults.setBool(false, forKey: "launchLogin")
            defaults.synchronize()
        }

        if defaults.boolForKey("launchLogin") == true {
            toggleItem.state = 1
        }
        else {
            toggleItem.state = 0
        }

        let quitItem = NSMenuItem()
        quitItem.title = "Quit Mojo"
        quitItem.action = "quitMojo"

        settingsMenu.addItem(toggleItem)
        settingsMenu.addItem(NSMenuItem.separatorItem())
        settingsMenu.addItem(quitItem)

        // Collection View / Scroll View

        collectionView!.layer?.backgroundColor = NSColor.clearColor().CGColor
        scrollView!.verticalScroller?.alphaValue = 0

        // Favorites
        
        if defaults.objectForKey("favorites") == nil {
            defaults.setObject([
                "❤️" : 1,
                "😍" : 1,
                "😊" : 1,
                "😂" : 1,
                "😁" : 1,
                "😉" : 1,
                "😅" : 1,
                "😡" : 1,
                "😜" : 1,
                "😥" : 1,
                "😨" : 1,
                "😩" : 1,
                "😭" : 1,
                "😱" : 1,
                "😳" : 1,
                "😷" : 1,
                "🙈" : 1,
                "🙉" : 1,
                "🙊" : 1,
                "🙏" : 1,
                "✊" : 1,
                "🚀" : 1,
                "🚅" : 1,
                "🚉" : 1,
                "🚌" : 1,
                "🚑" : 1,
                "🚒" : 1,
                "🚓" : 1,
                "🚗" : 1,
                "🚚" : 1,
                "🚤" : 1,
                "🚫" : 1,
                "🚬" : 1,
                "🚲" : 1,
                "🚽" : 1,
                "⏳" : 1,
                "☕" : 1,
                "♻" : 1,
                "⚽️" : 1,
                "⚡" : 1,
                "⛄" : 1,
                "⛔" : 1,
                "⛵" : 1,
                "🌂" : 1,
                "🌙" : 1,
                "🍷" : 1,
                "🍺" : 1,
                "🍴" : 1] ,forKey: "favorites")
            defaults.synchronize()
        }
        favorites = defaults.objectForKey("favorites") as! [String: Int]
    }

    override func viewDidAppear() {
        self.view.window!.makeFirstResponder(searchField)
        NSApplication.sharedApplication().activateIgnoringOtherApps(true)
    }

    override func viewWillAppear() {
        appearance = NSUserDefaults.standardUserDefaults().stringForKey("AppleInterfaceStyle") ?? "Light"
        darkMode()
        if (searchField!.stringValue == "") {
            search("")
        }
    }

    override func viewWillDisappear() {
        defaults.setObject(favorites, forKey: "favorites")
    }

    // Visuals

    func darkMode() {
        if (appearance == "Dark") {
            popover.backgroundColor = NSColor.clearColor()
        }
        else {
            popover.backgroundColor = NSColor(hexString: "#FFFFFF")
        }
    }

    func emojiWasClicked() {
        self.instructions!.stringValue = "Copied"
        clickedTimer.invalidate()
        clickedTimer = NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "showInstructions", userInfo: nil, repeats: false)
    }

    func showInstructions() {
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = 0.1
            self.instructions!.animator().alphaValue = 0
            }, completionHandler: { () -> Void in
                self.instructions!.stringValue = "Click to copy"
                self.instructions!.animator().alphaValue = 1
        })
    }

    func clearSearch() {
        searchField.stringValue = ""
        search("")
    }

    // Settings

    @IBAction func clickedSettings(sender: NSButton) {
        let frame = sender.frame
        let menuOrigin = NSMakePoint(frame.origin.x + frame.size.width + 5, frame.origin.y + frame.size.height / 2 - 2)
        let event = NSEvent.mouseEventWithType(.LeftMouseDown, location: menuOrigin, modifierFlags: NSEventModifierFlags.ShiftKeyMask, timestamp: 0, windowNumber: sender.window!.windowNumber, context: sender.window?.graphicsContext, eventNumber: 0, clickCount: 1, pressure: 1)
        NSMenu.popUpContextMenu(settingsMenu, withEvent: event!, forView: sender)
    }

    func toggleLaunch(sender: NSMenuItem) {
        if sender.state == 0 {
            if SMLoginItemSetEnabled("com.elliottbolzan.Mojo-Helper", Bool(1)) == Bool(1) {
                sender.state = 1
                defaults.setBool(true, forKey: "launchLogin")
            }
        }
        else if sender.state == 1 {
            if SMLoginItemSetEnabled("com.elliottbolzan.Mojo-Helper", Bool(0)) == Bool(1) {
                sender.state = 0
                defaults.setBool(false, forKey: "launchLogin")
            }
        }
        defaults.synchronize()
    }

    func quitMojo() {
        NSApp.terminate(self)
    }

    // Search Process

    @IBAction func changedText(sender: NSSearchField) {
        let string = searchField!.stringValue.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        search(string)
    }

    func search(searchString: String) {
        if (queue.operationCount != 0) {
            queue.cancelAllOperations()
            queue.waitUntilAllOperationsAreFinished()
        }
        let operation = SearchOperation(searchString: searchString)
        operation.completionBlock = {
            dispatch_async(dispatch_get_main_queue()) {
                self.updateContent()
            }
        }
        queue.addOperation(operation)
    }

    func updateContent() {
        content = searchOutput
        if (content.count == 0) {
            noResults!.hidden = false
            instructions?.stringValue = "No results"
            collectionView!.reloadData()
            return
        }
        instructions?.stringValue = "Click to copy"
        noResults!.hidden = true
        NSAnimationContext.currentContext().duration = 0.5
        collectionView!.reloadData()
    }

    // Collection View

    func collectionView(collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }

    func collectionView(collectionView: NSCollectionView, itemForRepresentedObjectAtIndexPath indexPath: NSIndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItemWithIdentifier("EmojiItem", forIndexPath: indexPath) as! EmojiItem
        item.representedObject = EmojiObject(title: content[indexPath.item])
        item.label.mojoController = self
        return item
    }
}
