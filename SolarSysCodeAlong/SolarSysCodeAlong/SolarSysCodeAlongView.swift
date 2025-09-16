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
    let depth: Float = -0.5
    
    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
            
            let boxEntity = ModelEntity(
                mesh: .generateBox( size: 0.25 ),
                materials: [SimpleMaterial( color: .blue, isMetallic: true )]
            )
            boxEntity.transform = Transform(translation: SIMD3(0, 0, depth))
            content.add(boxEntity)
            
            let sphereEntity = ModelEntity(
                mesh: .generateSphere(radius: 0.25),
                materials: [SimpleMaterial(color: .red, isMetallic: true)]
            )
            sphereEntity.transform = Transform(translation: SIMD3(1, 0, depth))
            content.add(sphereEntity)
            
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
            
            if let hapiLabTexture = try? await TextureResource(named: "HAPI-lab", in: SolarSysRealityKitResources.bundle) {
                let mesh = MeshResource.generateSphere(radius: 0.25)
                let material = UnlitMaterial(texture: hapiLabTexture)
                let hapiSphere = ModelEntity(mesh: mesh, materials: [material])
                hapiSphere.transform = Transform(translation: SIMD3(0, 0.5, depth))
                content.add(hapiSphere)

            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SolarSysCodeAlongView()
}
