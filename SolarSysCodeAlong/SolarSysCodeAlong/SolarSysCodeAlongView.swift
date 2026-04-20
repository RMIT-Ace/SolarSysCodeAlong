//
//  ContentView.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//
//  Notes:
//  (1) Simple Box shape with ModelEntity() - mesh and materials
//  (1a) Depth (meter) - distance away from camera for easy viewing
//  (2) Simple Sphere shape. Note on translation to move object from overlapping each others.
//  (3) Simple box entity with custom texture.
//  (3a) Import SolarSysRealityKet provides extra pre-made 3d assets and resources.
//  (4) Create 3D entity as Skybox! Note on a) Radius, b) Negative scale
//  (5) Load pre-made 3D model, i.e. Earth. Note on getting resource from SolarSysRealityKit package
//
//  Exercises:
//  (E1) Playaround with different textures
//  (E2) Experiment with different negative scale for skybox.

import SwiftUI
import RealityKit
import SolarSysRealityKit       // (3a)

struct SolarSysCodeAlongView: View {
    let depth: Float = -0.5     // (1a)
    let trackingSession = SpatialTrackingSession()
    
    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking

            // Configure spatial tracking without occlusion so real-world objects don't interfere with skybox
            let config = SpatialTrackingSession.Configuration(
                tracking: [.camera, .world, .plane, .object, .image],
                sceneUnderstanding: [.shadow, .collision, .physics],
                camera: .back
            )
            await trackingSession.run(config)
            
            // (1) _solarsimplebox
            let boxEntity = ModelEntity(
                mesh: .generateBox( size: 0.25 ),
                materials: [SimpleMaterial( color: .blue, isMetallic: true )]
            )
            boxEntity.transform = Transform(translation: SIMD3(0, 0, depth))
            content.add(boxEntity)
            
            // (2) _solarsimplesphere
            let sphereEntity = ModelEntity(
                mesh: .generateSphere(radius: 0.25),
                materials: [SimpleMaterial(color: .red, isMetallic: true)]
            )
            sphereEntity.transform = Transform(translation: SIMD3(1, 0, depth))
            content.add(sphereEntity)
            
            // (3) _solarboxstar
            let startfieldTexture = try? await TextureResource(
                named: "starfield",
                in: SolarSysRealityKitResources.bundle,
            )
            if startfieldTexture != nil {
                let mesh = MeshResource.generateBox(size: 0.5)
                let material = UnlitMaterial(texture: startfieldTexture!)
                let boxWithStars = ModelEntity(mesh: mesh, materials: [material])
                boxWithStars.transform = Transform(translation: SIMD3(-1, 0, depth))
                content.add(boxWithStars)
            } else {
                print("DEBUG: Can't load starfield.")
            }
            
            // (4) _solarsimpleskybox
            if let hapiLabTexture = try? await TextureResource(
                named: "puresky",
                in: SolarSysRealityKitResources.bundle
            ) {
                let mesh = MeshResource.generateSphere(radius: 100)
                let material = UnlitMaterial(texture: hapiLabTexture)
                let hapiSphere = ModelEntity(mesh: mesh, materials: [material])
                hapiSphere.transform = Transform(translation: SIMD3(0, 0.5, depth))
                content.add(hapiSphere)
                hapiSphere.transform.scale = SIMD3(-1, 1, 1)
            }
            
            // (5) _solar3dmodel
            if let url = SolarSysRealityKitResources.bundle.url(
                forResource: "Earth",
                withExtension: "usdz"
            ),
               let earth = try? await ModelEntity(contentsOf: url) {
                earth.transform = Transform(translation: SIMD3(0, -0.5, depth))
                content.add(earth)
            } else {
                print("DEBUG: Can't load Earth.")
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SolarSysCodeAlongView()
}
