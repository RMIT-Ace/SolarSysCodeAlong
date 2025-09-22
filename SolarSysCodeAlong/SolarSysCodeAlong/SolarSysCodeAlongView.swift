//
//  ContentView.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//
//  Notes:
//  (1) Discuss repeating blocks of code everywhere. Introduce MVVM paradigm
//  (2) Create new type 'CelestialEntity' that hold necessary info for our celestial objects.
//      See: CelestialObject.swift. This file belongs to Model layer in MVVM
//  (3) Create a ViewModel 'SolarSysViewModel', see: SolarSysViewModel.swift
//  (4a) Passing a ViewModel into a view
//  (4b) Create an instance and pass it to the view
//  (4c) Create an instance and pass it to the view (SolarSysCodeAlongApp.swift)

import SwiftUI
import RealityKit
import SolarSysRealityKit

struct SolarSysCodeAlongView: View {
    // (4a) Requires a ViewModel to work with.
    @Environment(SolarSysViewModel.self) private var vm
    
    static let secondsInOneEarthRotation: Float = .pi * 2.0
    
    @State var root: CelestialEntity!
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
            
            root = CelestialEntity()
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
                sun.addChild(earth)
            }
            
            // 3D Model - Moon
            moon = await CelestialEntity(
                bundle: SolarSysRealityKitResources.bundle,
                name: "Moon",
                scale: 1.0 / 2.0,
                distanceFromCenter: 0.2)
            if let earth = earth, let moon = moon {
                earth.addChild(moon)
            }

        } update: { content in
            Task {
                await sun?.updateRotation(speed: standardSpeed / 27.0)  // 27 Earth-day
                await earth?.updateRotation(speed: standardSpeed / 10.0) // One day
                await earth?.updateOrbit(speed: standardSpeed / 10)     // 10 days
                await moon?.updateRotation(speed: standardSpeed / 2.0) // 2 days
                await moon?.updateOrbit(speed: standardSpeed / 0.5)     // 5 days
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
        .environment(SolarSysViewModel())   // (4b) Create an instance and pass it to the view
}
