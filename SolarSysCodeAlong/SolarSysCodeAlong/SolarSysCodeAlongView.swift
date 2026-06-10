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
    
    let trackingSession = SpatialTrackingSession()

    var body: some View {
        ZStack {
            RealityView { content in
                content.camera = .spatialTracking
                await setCameraTracking()
                
                content.add(await SkyboxEntity(.nebula))
                content.add(await CrosshairEntity(action: updateCrosshairDisplay))
                
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
    
    private func updateCrosshairDisplay(target: Entity?, distance: Float) {
        targetText = "\(target?.parent?.name ?? "")"
        if targetText.isEmpty {
            targetDistance = ""
        } else {
            targetDistance = String(format: "%0.2f m", distance)
        }
    }
    
    func setCameraTracking() async {
            let config = SpatialTrackingSession.Configuration(
                tracking: [.camera, .world, .plane, .object, .image],
                sceneUnderstanding: [.shadow, .collision, .physics],
                camera: .back
            )
            await trackingSession.run(config)
        }
}

#Preview {
    SolarSysCodeAlongView()
        .environment(SolarSysViewModel())
}

