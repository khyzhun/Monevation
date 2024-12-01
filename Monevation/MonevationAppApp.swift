//
//  AppDelegate.swift
//  Monevation
//
//  Created by Alexander Khyzhun on 29.11.2024.
//

import SwiftUI

@main
struct MonevationAppApp: App {
    
    @State var currentNumber: String = "1"
    
    var body: some Scene {
        MenuBarExtra(currentNumber) {
            Button("One") {
                currentNumber = "1"
            }
            Button("Two") {
                currentNumber = "2"
            }
            Button("Settings") {
                // TODO: open a new window.
            }
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        }
    }
}
