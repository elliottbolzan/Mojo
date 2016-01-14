//
//  EmojiItem.swift
//  Mojo
//
//  Created by Elliott Bolzan on 11/28/15.
//  Copyright © 2015 Elliott Bolzan. All rights reserved.
//

import Foundation
import AppKit

class EmojiObject: NSObject {
    var title: String

    init(title: String) {
        self.title = title
    }
}

class EmojiDisplay: NSTextField {

    var mojoController: MojoViewController! = nil

    override func mouseDown(theEvent : NSEvent) {

        // Call Delegate

        mojoController!.emojiWasClicked()

        // Visuals

        animate()

        // Copy Code

        let pasteBoard = NSPasteboard.generalPasteboard()
        pasteBoard.clearContents()
        pasteBoard.writeObjects([self.stringValue])

        // Update Counts

        if (favorites[self.stringValue] != nil) {
            favorites[self.stringValue]? += 1
        }
        else {
            favorites[self.stringValue] = 1
        }

    }

    func animate() {
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fillMode = kCAFillModeForwards
        rotate.fromValue = 0.0
        rotate.toValue = CGFloat(M_PI * 2.0)
        rotate.duration = 0.2
        self.layer?.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.layer?.anchorPoint = CGPointMake(0.5, 0.5)
        self.layer?.addAnimation(rotate, forKey: nil)
    }
    
}

class EmojiItem: NSCollectionViewItem {

    @IBOutlet weak var label: EmojiDisplay!

    var emojiObject: EmojiObject? {
        return representedObject as? EmojiObject
    }

    override func viewDidLoad() {
        label.font = NSFont(name: "Apple Color Emoji", size: 32)
        label.editable = false
        label.bordered = false
        label.wantsLayer = true
        label.drawsBackground = true
        label.backgroundColor = NSColor.clearColor()
    }

}


