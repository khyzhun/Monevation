//
//  AppDelegate.swift
//  Monevation
//
//  Created by Alexander Khyzhun on 29.11.2024.
//

import SwiftUI
import AppKit

@main
struct MonevationAppApp: App {
    
    // MARK: - State
    @State private var timer: Timer?
    @State private var startTime: Date?
    @State private var totalEarned: Double = 0.0
    @State private var hourlyRate: Double = 25.0
    
    enum UpdateOption: String, CaseIterable {
        case every_minute = "Update every minute"
        case every_five_minutes = "Update every 5 minutes"
        case every_fifteen_minutes = "Update every 15 minutes"
    }
    
    @State private var selectedUpdateOption: UpdateOption = .every_minute
    
    // MARK: - Constants
    private let oneMinute: TimeInterval = 60
    private let fiveMinutes: TimeInterval = 5 * 60
    private let fifteenMinutes: TimeInterval = 15 * 60
    
    var body: some Scene {
        MenuBarExtra {
            // Display total earned
            Text("Total Earned: \(formattedEarnings)")
                .padding()
            
            Divider()
            
            // Start button
            Button("Start") {
                startTracking()
            }
            
            // Stop button
            Button("Stop") {
                stopTracking()
            }
            
            // Settings menu
            Menu("Settings") {
                settingsMenuContent
            }
            
            Divider()
            
            // Quit button
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
            
        } label: {
            HStack {
                Image(systemName: "dollarsign.circle")
                    .renderingMode(.template)
                Text(" \(formattedEarnings)")
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var formattedEarnings: String {
        String(format: "$%.2f", totalEarned)
    }
    
    private var settingsMenuContent: some View {
        ForEach(UpdateOption.allCases, id: \.self) { option in
            Button(action: {
                selectedUpdateOption = option
            }) {
                Label(option.rawValue, systemImage: selectedUpdateOption == option ? "checkmark" : "")
            }
        }
    }
    
    // MARK: - Methods
    
    private func startTracking() {
        startTime = Date()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: intervalForUpdateOption(selectedUpdateOption), repeats: true) { _ in
            updateEarnings()
        }
    }
    
    private func stopTracking() {
        timer?.invalidate()
        timer = nil
    }
    
    private func intervalForUpdateOption(_ option: UpdateOption) -> TimeInterval {
        switch option {
        case .every_minute:
            return oneMinute
        case .every_five_minutes:
            return fiveMinutes
        case .every_fifteen_minutes:
            return fifteenMinutes
        }
    }
    
    private func updateEarnings() {
        guard let startTime = startTime else { return }
        
        let elapsedTime = Date().timeIntervalSince(startTime)
        // Calculate total earned based on hourly rate and elapsed time (in hours)
        totalEarned = (elapsedTime / 3600.0) * hourlyRate
    }
    
    func openSettings() {
        let settingsWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 150),
            styleMask: [.titled, .closable],
            backing: .buffered, defer: false
        )
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
