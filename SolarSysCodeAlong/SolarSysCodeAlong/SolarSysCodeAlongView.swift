//
//  ContentView.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//

import SwiftUI
import RealityKit
import SolarSysRealityKit

struct SolarSysCodeAlongView: View {
    @Environment(SolarSysViewModel.self) private var vm
    
    static let secondsInOneEarthRotation: Float = .pi * 2.0
    
    @State var root: CelestialEntity!
    @State var secondsInOneEarthDay: Float = 1.0
    
    @State private var targetText: String = ""
    @State private var targetDistance: String = ""

    var standardSpeed: Float {
        Self.secondsInOneEarthRotation / secondsInOneEarthDay
    }

    var body: some View {
        ZStack {
            RealityView { content in
                content.camera = .spatialTracking
                
                content.add(await SkyboxEntity(.nebula))
                content.add(await CrosshairEntity { target, distance  in
                    targetText = "\(target?.parent?.name ?? "")"
                    if targetText.isEmpty {
                        targetDistance = ""
                    } else {
                        targetDistance = String(format: "%0.2f m", distance)
                    }
                })
                
                root = CelestialEntity()
                content.add(root)
                root.position.z = -2.0
                
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
            
            // Z-1 Head-up display
            VStack {
                Text(targetText)
                    .font(Font.largeTitle.bold())
                    .foregroundStyle(Color.white)
                Text(targetDistance)
                    .font(Font.subheadline.bold())
                    .foregroundStyle(Color.white)
                Spacer()
            }
        }
    }
}

#Preview {
    SolarSysCodeAlongView()
        .environment(SolarSysViewModel())
}

