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
        WindowGroup {
            LaunchView()
        }
        .windowStyle(.plain)

        ImmersiveSpace(id: "solarSystem") {
            SolarSysCodeAlongView()
        }
        .immersionStyle(selection: $immersionStyle, in: .full)
    }
}

struct LaunchView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissWindow) private var dismissWindow

    var body: some View {
        Color.clear
            .task {
                await openImmersiveSpace(id: "solarSystem")
            }
    }
}
