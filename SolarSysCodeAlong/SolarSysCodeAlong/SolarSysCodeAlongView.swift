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
    
    var standardSpeed: Float {
        Self.secondsInOneEarthRotation / secondsInOneEarthDay
    }

    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
            
            await makeSkybox(content)
            
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
    
    private func makeSkybox(_ content: RealityViewCameraContent) async {
        // Skybox
        if let hapiLabTexture = try? await TextureResource(named: "starfield", in: SolarSysRealityKitResources.bundle) {
            let mesh = MeshResource.generateSphere(radius: 10)
            let material = UnlitMaterial(texture: hapiLabTexture)
            let hapiSphere = ModelEntity(mesh: mesh, materials: [material])
            content.add(hapiSphere)
            hapiSphere.transform.scale = SIMD3(-1, 1, 1)
        }
    }
}

#Preview {
    SolarSysCodeAlongView()
        .environment(SolarSysViewModel())
}

