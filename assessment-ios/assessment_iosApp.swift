//
//  assessment_iosApp.swift
//  assessment-ios
//
//  Created by Ivan Trejo on 15/04/23.
//

import SwiftUI

@main
struct assessment_iosApp: App {

    init() {
        NetworkMonitor.shared.startMonitoring()
    }

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel.make())
        }
    }
}
