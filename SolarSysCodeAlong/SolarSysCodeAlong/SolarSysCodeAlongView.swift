//
//  ContentView.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//
//  Notes:
//  (1) Remove all codes from previous exercise, except skybox code.
//  (2) Refactor code that creates skybox into a resuable function.
//  (2a) Call skybox function to create skybox for our code.
//  (3) Create entities
//  (3a) Big blue box entity
//  (3b) Earth entity
//  (4) Adding Component and System - see:
//  (4a) RotationComponent and
//  (4b) RotationSystem
//  (5) Make entity rotates
//  (5a) Make blue box rotates
//  (5b) Make Earth rotates
//  (5c) Make Sun rotates
//
//  Exercises:
//  (E1) Make the blue box invisible!

import SwiftUI
import RealityKit
import SolarSysRealityKit

struct SolarSysCodeAlongView: View {
    
    let depth: Float = -4.0
    let boxSize: Float = 2.0
    
    var body: some View {
        RealityView { content in
            
            await makeSkybox(content)
            
            if let url = SolarSysRealityKitResources.bundle.url(
                forResource: "Sun",
                withExtension: "usdz"
            ),
               let sun = try? await ModelEntity(contentsOf: url) {
                content.add(sun)
                sun.transform = Transform(translation: SIMD3(0, 0, depth))
                sun.scale = SIMD3(repeating: 4)
                sun.components.set(
                    RotationComponent(rotationSpeed: 1.0, rotationAxis: [0, -1, 0])
                )
                
                if let url = SolarSysRealityKitResources.bundle.url(
                    forResource: "Earth",
                    withExtension: "usdz"
                ),
                   let earth = try? await ModelEntity(contentsOf: url) {
                    sun.addChild(earth)
                    earth.position.x = boxSize / 2.0
                    earth.components.set( RotationComponent(rotationSpeed: 5.0) )
                    
                    if let url = SolarSysRealityKitResources.bundle.url(
                        forResource: "Moon",
                        withExtension: "usdz"
                    ),
                       let moon = try? await ModelEntity(contentsOf: url) {
                        moon.position.x = 0.3
                        moon.scale = SIMD3(repeating: 0.3)
                        earth.addChild(moon)
                    }
                }
            }

            
        }
        .onAppear {
            RotationSystem.registerSystem()
        }
        
        .ignoresSafeArea()
    }
    
    private func makeSkybox(_ content: RealityViewCameraContent) async {
        // Skybox
        if let hapiLabTexture = try? await TextureResource(
            named: "starfield",
            in: SolarSysRealityKitResources.bundle
        ) {
            let mesh = MeshResource.generateSphere(radius: 20)
            let material = UnlitMaterial(texture: hapiLabTexture)
            let hapiSphere = ModelEntity(mesh: mesh, materials: [material])
            hapiSphere.transform.scale = SIMD3(-1, 1, 1)
            content.add(hapiSphere)
        }
    }
    
}

#Preview {
    SolarSysCodeAlongView()
}
