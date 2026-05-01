//
//  SolarSysCodeAlongApp.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//

import SwiftUI

@main
struct SolarSysCodeAlongApp: App {
    @State private var immersionStyle: ImmersionStyle = .full

    var body: some Scene {
        ImmersiveSpace {
            SolarSysCodeAlongView()
        }
        .immersionStyle(selection: $immersionStyle, in: .full)
    }
}
