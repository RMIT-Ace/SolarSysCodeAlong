//
//  ContentView.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//
//  Notes:
//  (1) Discuss code repetition when creating/adding entities.
//  (2) Create CelestialEntity (see: CelestialEntity.swift). Walkthrough the code.
//  (2a) MainBody - Container for pivoting/orbiting.
//  (2b) For adding children. No Visual appearance..
//  (2c) Call the overridden 'addChild()'
//  (2d) Overwrite 'addChild()'
//  (3) Root entity
//  (4) Sun entity
//  (5) Earth entity
//  (6) Moon entity
//  (7) RealityView update block
//  (8a) One complete circle = 2π
//  (8b) 2π / Number of sections (days) to break it down.
//

import SwiftUI
import RealityKit
import SolarSysRealityKit

struct SolarSysCodeAlongView: View {
    // (8a) One complete circle =  2π
    static let secondsInOneEarthRotation: Float = .pi * 2.0
    
    @State var root: Entity!
    @State var sun: CelestialEntity?
    @State var earth: CelestialEntity?
    @State var moon: CelestialEntity?
    @State var secondsInOneEarthDay: Float = 1.0
    
    // (8b) 2π / Number of sections (days) to break it down.
    var standardSpeed: Float {
        Self.secondsInOneEarthRotation / secondsInOneEarthDay
    }

    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
            
            await makeSkybox(content)
            
            // (3) _solarroot
            root = Entity()
            content.add(root)
            root.position.z = -1.0
            
            // (4) _solarcesun
            // 3D Model - Sun
            sun = await CelestialEntity(
                bundle: SolarSysRealityKitResources.bundle,
                name: "Sun",
                scale: 3.0,
                distanceFromCenter: 0.0)
            if let sun = sun {
                root.addChild(sun)
            }

            // (5) _solarceearth
            // 3D Model - Earth
            earth = await CelestialEntity(
                bundle: SolarSysRealityKitResources.bundle,
                name: "Earth",
                scale: 1.0,
                distanceFromCenter: 1.0)
            if let earth = earth, let sun = sun {
                sun.addChild(earth)
            }
            
            // (6) _solarcemoon
            // 3D Model - Moon
            moon = await CelestialEntity(
                bundle: SolarSysRealityKitResources.bundle,
                name: "Moon",
                scale: 1.0 / 2.0,
                distanceFromCenter: 0.2)
            if let earth = earth, let moon = moon {
                earth.addChild(moon)
            }

        // (7) _solarrealityupdate
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
