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
            
            // (4) _solarcesun
            
            // (5) _solarceearth
            
            // (6) _solarcemoon

        // (7) _solarrealityupdate
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
