//
//  AppDelegate.swift
//  Monevation
//
//  Created by Alexander Khyzhun on 29.11.2024.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem!
    var popover: NSPopover!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "dollarsign.circle", accessibilityDescription: "Monevation")
            button.action = #selector(togglePopover(_:))
        }
        
        // Створюємо поповер для меню
        popover = NSPopover()
        popover.contentViewController = MenuViewController.freshController()
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            popover.performClose(sender)
        } else {
            if let button = statusItem.button {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }
}
