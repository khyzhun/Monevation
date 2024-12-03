//
//  AppDelegate.swift
//  Monevation
//
//  Created by Alexander Khyzhun on 29.11.2024.
//

import SwiftUI

@main
struct MonevationAppApp: App {
        
    @State private var timer: Timer?
    @State private var startTime: Date?
    @State private var totalEarned: Double = 0.0
    @State private var hourlyRate: Double = 45.0 // TODO: calculate income based on this value insteaf of mock.
    
    enum UpdateOption: String, CaseIterable {
        case every_minute = "Update every minute"
        case every_five_minutes = "Update every 5 minutes"
        case every_fifteen_minutes = "Update every 15 minutes"
    }
    
    @State private var selectedUpdateOption: UpdateOption = .every_minute
    
    var body: some Scene {
        MenuBarExtra {
            Text("Total Earned: $\(String(format: "%.2f", totalEarned))").padding()
            Divider()
            Button("Start") {
                startTime = Date()
                // TODO: need to change Interval by selecting UpdateOptions.
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                    updateEarnings()
                }
            }
            Button("Stop") {
                timer?.invalidate()
                timer = nil
            }
            Menu("Settings") {
                ForEach(UpdateOption.allCases, id: \.self) { option in
                     Button(action: {
                         selectedUpdateOption = option
                     }) {
                         Label(option.rawValue, systemImage: selectedUpdateOption == option ? "checkmark" : "")
                     }
                 }
            }
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }.keyboardShortcut("q")
        } label: {
            HStack {
               Image(systemName: "dollarsign.circle").renderingMode(.template)
               Text(" $\(String(format: "%.2f", totalEarned))")
           }
        }
    }
    
    func updateEarnings() {
        if let startTime = startTime {
            let elapsedTime = Date().timeIntervalSince(startTime)
            switch selectedUpdateOption {
            case .every_minute:
                totalEarned = Double(elapsedTime / 60)
             case .every_five_minutes:
                totalEarned = Double(elapsedTime / (5 * 60))
             case .every_fifteen_minutes:
                totalEarned = Double(elapsedTime / (15 * 60))
             }
        }
    }
    
    func openSettings() {
        let settingsWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 150),
            styleMask: [.titled, .closable],
            backing: .buffered, defer: false)
        settingsWindow.center()
        settingsWindow.title = "Settings"
        settingsWindow.contentView = NSHostingView(rootView: SettingsView(hourlyRate: $hourlyRate))
        settingsWindow.makeKeyAndOrderFront(nil)
    }
}

struct SettingsView: View {
    @Binding var hourlyRate: Double

    var body: some View {
        VStack {
            Text("Settings")
                .font(.headline)
            HStack {
                Text("Hourly Rate:")
                TextField("Hourly Rate", value: $hourlyRate, formatter: NumberFormatter())
                    .frame(width: 100)
            }
            .padding()
            Button("Close") {
                NSApp.keyWindow?.close()
            }
        }
        .padding()
    }
}
