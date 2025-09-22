//
//  ContentView.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//
//  Notes:
//  (1) Notice skybox function is useful and can be reused elsewhere.
//  (2) Refactor Skybox and put it in a package SolarSysRealityKit.
//      Walkthrough the code.
//  (3) Simply (re)use skybox code provided by the package.
//
//  Exercises:
//  (4) Experiment with different skyboxes.
//

import SwiftUI
import RealityKit
import SolarSysRealityKit

struct SolarSysCodeAlongView: View {
    @Environment(SolarSysViewModel.self) private var vm
    
    static let secondsInOneEarthRotation: Float = .pi * 2.0
    
    @State var root: CelestialEntity!
    @State var secondsInOneEarthDay: Float = 1.0
    
    var standardSpeed: Float {
        Self.secondsInOneEarthRotation / secondsInOneEarthDay
    }

    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
            
            // (3) Reuse code from SolarSysRealityKit package.
            content.add(await SkyboxEntity(.nebula))

            root = CelestialEntity()
            content.add(root)
            root.position.z = -1.0
            
            await vm.setupCelestialSystem(for: root)
            
        } update: { content in
            Task {
                await vm
                    .updateCelestialMovements(
                        in: root,
                        for: vm.celestialObjects.first,
                        standardSpeed: standardSpeed
                    )
            }
        }
        .onAppear {
            RotationSystem.registerSystem()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SolarSysCodeAlongView()
        .environment(SolarSysViewModel())
}

