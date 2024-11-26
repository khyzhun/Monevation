//
//  MonevationApp.swift
//  Monevation
//
//  Created by Alexander Khyzhun on 26.11.2024.
//

import SwiftUI
import AppKit

@main
struct MonevationApp: App {
    
    @StateObject private var monevactionViewModel = MonevationViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    monevactionViewModel.setupToolbar()
                }
        }
    }
}
