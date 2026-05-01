//
//  SolarSysCodeAlongApp.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//

import SwiftUI
import RealityKit

@main
struct SolarSysCodeAlongApp: App {
    @State private var immersionStyle: ImmersionStyle = .full

    init() {
        RotationComponent.registerComponent()
        RotationSystem.registerSystem()
    }

    var body: some SwiftUI.Scene {
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
