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
            
            await addCelestialEntity(
                to: root,
                celestialObj: vm.celestialObjects.first
            )
            
        } update: { content in
            Task {
                await updateCelestialMovements(
                    in: root,
                    for: vm.celestialObjects.first,
                    standardSpeed: standardSpeed)
            }
        }
        .onAppear {
            RotationSystem.registerSystem()
        }
        .ignoresSafeArea()
    }
    
    private func updateCelestialMovements(
        in parent: CelestialEntity,
        for celestialObject: CelestialObject?,
        standardSpeed: Float
    ) async {
        guard let celestialObject else { return }
        guard let celestialEntity = root.findEntity(named: celestialObject.name) as? CelestialEntity else {
            print(">> WARN: Could not find model for \(celestialObject.name)")
            return
        }
        await celestialEntity.updateRotation(speed: standardSpeed / celestialObject.rotationSpeed)
        await celestialEntity.updateOrbit(speed: standardSpeed / celestialObject.orbitalSpeed)
        for child in celestialObject.satellites {
            await updateCelestialMovements(in: celestialEntity, for: child, standardSpeed: standardSpeed)
        }
    }
    
    private func addCelestialEntity(
        to parent: CelestialEntity,
        celestialObj: CelestialObject?
    ) async {
        guard let celestialObj = celestialObj else { return }
        guard let newCelestialEntity = await CelestialEntity(
            bundle: SolarSysRealityKitResources.bundle,
            name: celestialObj.name,
            scale: celestialObj.scale,
            distanceFromCenter: celestialObj.distanceCenter
        )  else {
            print(">> WARN: Could not create model for \(celestialObj.name)")
            return
        }
        parent.addChild(newCelestialEntity)
        for child in celestialObj.satellites {
            await addCelestialEntity( to: newCelestialEntity, celestialObj: child )
        }
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

