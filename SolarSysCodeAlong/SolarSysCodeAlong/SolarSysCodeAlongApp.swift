//
//  SolarSysCodeAlongApp.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//

import SwiftUI

@main
struct SolarSysCodeAlongApp: App {
    var body: some Scene {
        WindowGroup {
            SolarSysCodeAlongView()
                .environment(SolarSysViewModel())
        }
    }
}
