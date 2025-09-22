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
//
//  (5) Define a function to setup celestial system - addCelestialEntity()
//  (5a) Calling the function to setup solar system.
//
//  (6) Refactor update movements code into a function
//  (6a) Calling update movement function
//  (7) Point out that View is not a good place for these 2 functions!
//
//  (8) Refactor functions into ViewModel - See 'SolarSysViewModel.swift'
//  (8a) Call update function from ViewModel.
//
//  Exercise:
//  (8b) Exercise - Adding Mars planet
//  (8c) Discuss benefits - i.e. adding new planet, no code change to view.
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
                //  (8a) Call update function from ViewModel.
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

