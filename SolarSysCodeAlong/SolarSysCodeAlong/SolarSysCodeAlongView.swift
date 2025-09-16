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
    
    let depth: Float = -3.0
    let boxSize: Float = 2.0
    
    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
            
            await makeSkybox(content)
            
            let box = ModelEntity(
                mesh: .generateBox(size: boxSize),
                materials: [
                    SimpleMaterial(
                        color: .blue.withAlphaComponent(0.2), isMetallic: false
                    )
                ]
            )
            box.transform = Transform(translation: SIMD3(0, 0, depth))
            content.add(box)
            box.components.set( RotationComponent(rotationSpeed: 1) )
            
            // 3D Model - Earth
            if let url = SolarSysRealityKitResources.bundle.url(forResource: "Earth", withExtension: "usdz"),
               let earth = try? await ModelEntity(contentsOf: url) {
                box.addChild(earth)
                earth.position.x = boxSize / 2.0
                earth.components.set(
                    RotationComponent(rotationSpeed: 20.0)
                )
                
                // 3D Model - Moon
                if let url = SolarSysRealityKitResources.bundle.url(forResource: "Moon", withExtension: "usdz"),
                   let moon = try? await ModelEntity(contentsOf: url) {
                    box.addChild(moon)
                    moon.position.x = 0.3
                    moon.scale = SIMD3(repeating: 0.3)
                    earth.addChild(moon)
                }
            }
            
            // 3D Model - Sun
            if let url = SolarSysRealityKitResources.bundle.url(forResource: "Sun", withExtension: "usdz"),
               let sun = try? await ModelEntity(contentsOf: url) {
//                box.addChild(sun)
                content.add(sun)
                sun.transform = Transform(translation: SIMD3(0, 0, depth))
                sun.scale = SIMD3(repeating: 4)
                sun.components.set(
                    // Speed of 1 will make it stands still. Must offset the speed of box.
                    RotationComponent(rotationSpeed: 1.0, rotationAxis: [0, -1, 0])
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
            hapiSphere.transform = Transform(translation: SIMD3(0, 0.5, depth))
            content.add(hapiSphere)
            hapiSphere.transform.scale = SIMD3(-1, 1, 1)
        }
    }
}

#Preview {
    SolarSysCodeAlongView()
}
