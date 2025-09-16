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
    
    static let secondsInOneEarthRotation: Float = .pi * 2.0
    
    @State var root: Entity!
    @State var sun: CelestialEntity?
    @State var earth: CelestialEntity?
    @State var moon: CelestialEntity?
    @State var secondsInOneEarthDay: Float = 1.0
    
    var standardSpeed: Float {
        Self.secondsInOneEarthRotation / secondsInOneEarthDay
    }

    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
            
            await makeSkybox(content)
            
            root = Entity()
            content.add(root)
            root.position.z = -1.0
            
            // 3D Model - Sun
            sun = await CelestialEntity(
                bundle: SolarSysRealityKitResources.bundle,
                name: "Sun",
                scale: 3.0,
                distanceFromCenter: 0.0)
            if let sun = sun {
                root.addChild(sun)
            }

            // 3D Model - Earth
            earth = await CelestialEntity(
                bundle: SolarSysRealityKitResources.bundle,
                name: "Earth",
                scale: 1.0,
                distanceFromCenter: 1.0)
            if let earth = earth, let sun = sun {
                sun.addChildToMainBody(earth)
            }
            
            // 3D Model - Moon
            moon = await CelestialEntity(
                bundle: SolarSysRealityKitResources.bundle,
                name: "Moon",
                scale: 1.0 / 2.0,
                distanceFromCenter: 0.2)
            if let earth = earth, let moon = moon {
                earth.addChildToMainBody(moon)
            }

        } update: { content in
            Task {
                await sun?.updateRotation(speed: standardSpeed / 27.0)  // 27 Earth-day
                await earth?.updateRotation(speed: standardSpeed / 1.0) // One day
                await earth?.updateOrbit(speed: standardSpeed / 10)     // 10 days
                await moon?.updateRotation(speed: standardSpeed / 2.0) // One day
                await moon?.updateOrbit(speed: standardSpeed / 10)     // 10 days
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
}
