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
    @State private var hourlyRate: Double = 36.0 // 1 cent for second (as a test).
    @State private var isPaused: Bool = false
    @State private var elapsedPausedTime: TimeInterval = 0.0
    @State private var settingsWindow: NSWindow? // Add a reference to the settings window

    enum UpdateOption: String, CaseIterable {
        case every_second = "Update every second" // to simplify testing.
        case every_minute = "Update every minute"
        case every_five_minutes = "Update every 5 minutes"
        case every_fifteen_minutes = "Update every 15 minutes"
    }
    
    @State private var selectedUpdateOption: UpdateOption = .every_second
    
    // MARK: - Constants
    private let oneSecond: TimeInterval = 1
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
            }.disabled(isTimerRunning)
            
            Button(isPaused ? "Resume" : "Pause") {
                pauseUnpauseTracking()
            }.disabled(!isTimerRunning)
            
            // Stop button
            Button("Stop") {
                stopTracking()
            }.disabled(!isTimerRunning)
            
            Divider()
            
            Menu("Set update interval") {
                settingsMenuContent
            }
            
            Button("Set hourly rate") {
                openSettings()
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
    
    private var isTimerRunning: Bool {
        return timer != nil
    }
    
    private var settingsMenuContent: some View {
        ForEach(UpdateOption.allCases, id: \.self) { option in
            Button(action: {
                selectedUpdateOption = option
                continueTimerWithNewOption()
            }) {
                HStack() {
                    Text(option.rawValue)
                    if selectedUpdateOption == option {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .padding(.leading, 8)
                    }
                }
            }
        }
    }
    
    // MARK: - Methods
    
    private func startTracking() {
        startTime = Date()
        isPaused = false
        let interval = intervalForUpdateOption(selectedUpdateOption)
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            updateEarnings()
        }
    }
    
    private func pauseUnpauseTracking() {
        if !isPaused {
              if let startTime = startTime {
                  elapsedPausedTime += Date().timeIntervalSince(startTime)
              }
              isPaused = true
              timer?.invalidate()
          } else {
              // If paused, resume the timer
              let interval = intervalForUpdateOption(selectedUpdateOption)
              startTime = Date().addingTimeInterval(-elapsedPausedTime)
              isPaused = false
              timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                  updateEarnings()
              }
          }
    }
    
    private func stopTracking() {
        timer?.invalidate()
        timer = nil
        isPaused = false
    }
    
    private func intervalForUpdateOption(_ option: UpdateOption) -> TimeInterval {
        switch option {
        case .every_second:
            return oneSecond
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
    
    private func continueTimerWithNewOption() {
        // Invalidate the old timer
        timer?.invalidate()

        // Save the previous total earned before switching intervals (in cents)
        let previousTotalEarnedInCents = totalEarnedInCents
        let currentTime = Date()
        
        // Convert the hourly rate to cents per second
        let hourlyRateInCentsPerSecond = (hourlyRate * 100) / 3600.0 // convert hourly rate to cents per second
        
        // Get the new interval and set it
        let interval = intervalForUpdateOption(selectedUpdateOption)
        
        // If there's an existing start time, calculate how much time has passed
        if let startTime = startTime {
            let elapsedTimeInSeconds = currentTime.timeIntervalSince(startTime) + elapsedPausedTime
            self.startTime = currentTime.addingTimeInterval(-elapsedTimeInSeconds)
            
            // Calculate the total earned in cents based on elapsed time (in seconds)
            totalEarnedInCents = previousTotalEarnedInCents + Int(elapsedTimeInSeconds) * Int(hourlyRateInCentsPerSecond)
        } else {
            self.startTime = currentTime
        }
        
        // Update earnings if enough time has passed based on the new interval
        let elapsedSinceStartInSeconds = currentTime.timeIntervalSince(startTime ?? currentTime) + elapsedPausedTime
        if elapsedSinceStartInSeconds >= interval {
            totalEarnedInCents = previousTotalEarnedInCents + Int(elapsedSinceStartInSeconds) * Int(hourlyRateInCentsPerSecond)
        }
        
        // Start the timer with the new interval
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            updateEarnings()
        }
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
        
        self.settingsWindow = settingsWindow
    }
}

struct SettingsView: View {
    @Binding var hourlyRate: Double

    var body: some View {
        VStack {
            Text("Settings").font(.headline)
            HStack {
                Text("Hourly Rate:")
                TextField("Hourly Rate", value: $hourlyRate, formatter: NumberFormatter()).frame(width: 100)
            }
            .padding()
            Button("Save") {
                if let settingsWindow = NSApp.keyWindow {
                    settingsWindow.close()
                }
            }
        }
        .padding()
    }
}
