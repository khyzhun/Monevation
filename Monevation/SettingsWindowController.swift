//
//  SettingsWindowController.swift
//  Monevation
//
//  Created by Alexander Khyzhun on 29.11.2024.
//

import Cocoa

class SettingsWindowController: NSWindowController {
    
    @IBOutlet weak var hourlyRateField: NSTextField!
    @IBOutlet weak var updateFrequencyPopup: NSPopUpButton!
    @IBOutlet weak var totalEarnedLabel: NSTextField!
    @IBOutlet weak var clearButton: NSButton!
    
    var hourlyRate: Double = 25.0
    var totalEarned: Double = 0.0
    
    override func windowDidLoad() {
        super.windowDidLoad()
        hourlyRateField.doubleValue = hourlyRate
        totalEarnedLabel.stringValue = String(format: "Total Earned: $%.2f", totalEarned)
        updateFrequencyPopup.addItems(withTitles: ["Every Minute", "Every Hour", "Every Day"])
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        hourlyRate = hourlyRateField.doubleValue
        window?.close()
    }
    
    @IBAction func clearClicked(_ sender: Any) {
        totalEarned = 0.0
        totalEarnedLabel.stringValue = String(format: "Total Earned: $%.2f", totalEarned)
    }
}
