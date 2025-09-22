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
                .environment(SolarSysViewModel())   // (4c) Create an instance and pass it to the view
        }
    }
}
