//
//  MenuViewController.swift
//  Monevation
//
//  Created by Alexander Khyzhun on 29.11.2024.
//

import Cocoa

class MenuViewController: NSViewController {
    
    @IBOutlet weak var earningsLabel: NSTextField!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var stopButton: NSButton!
    @IBOutlet weak var settingsButton: NSButton!
    
    var timer: Timer?
    var startTime: Date?
    var hourlyRate: Double = 25.0  // За замовчуванням $25 на годину
    var totalEarned: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateEarningsLabel()
    }
    
    @IBAction func startClicked(_ sender: Any) {
        startTime = Date()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateEarnings), userInfo: nil, repeats: true)
    }
    
    @IBAction func stopClicked(_ sender: Any) {
        timer?.invalidate()
        timer = nil
    }
    
    @IBAction func settingsClicked(_ sender: Any) {
        let settingsWindow = SettingsWindowController(windowNibName: "SettingsWindow")
        settingsWindow.showWindow(nil)
    }
    
    @objc func updateEarnings() {
        guard let startTime = startTime else { return }
        let elapsedTime = Date().timeIntervalSince(startTime)
        totalEarned = (elapsedTime / 3600) * hourlyRate
        updateEarningsLabel()
    }
    
    func updateEarningsLabel() {
        earningsLabel.stringValue = String(format: "Total Earned: $%.2f", totalEarned)
    }
    
    static func freshController() -> MenuViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier("MenuViewController")
        guard let viewController = storyboard.instantiateController(withIdentifier: identifier) as? MenuViewController else {
            fatalError("Unable to find MenuViewController in storyboard.")
        }
        return viewController
    }
}
