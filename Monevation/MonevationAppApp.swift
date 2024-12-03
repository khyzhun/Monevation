//
//  AppDelegate.swift
//  Monevation
//
//  Created by Alexander Khyzhun on 29.11.2024.
//

import SwiftUI

@main
struct MonevationAppApp: App {
    
    var body: some Scene {
        MenuBarExtra {
            Button("Start") {
                // TODO: start the timer
            }
            Button("Stop") {
                // TODO: stop the timer
            }
            Button("Settings") {
                // TODO: open a new window.
            }
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        } label: {
            Image(systemName: "dollarsign.circle")
        }
    }
}
