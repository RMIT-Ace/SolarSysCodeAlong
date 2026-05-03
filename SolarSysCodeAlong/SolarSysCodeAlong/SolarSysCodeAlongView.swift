//
//  ContentView.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//

// Beginner-06
// 1) Fully immersive on Vision Pro

import SwiftUI
import RealityKit

struct SolarSysCodeAlongView: View {
    var body: some View {
        RealityView { content in
            await makeSkybox(content)

            for _ in 0..<20 {
                addSphere(
                    to: content,
                    size: getRandomSize(),
                    color: getRandomColor(),
                    position: getRandomPosition()
                )
            }
        }
    }

    func addSphere(
        to content: RealityViewContent,
        size: Float,
        color: SimpleMaterial.Color,
        position: SIMD3<Float>
    ) {
        let centerEntity = Entity()
        centerEntity.components.set(RotationComponent(rotationSpeed: getRandomRotationSpeed()))

        let sphere = ModelEntity(
            mesh: .generateSphere(radius: size / 2.0),
            materials: [SimpleMaterial(color: color, isMetallic: true)]
        )
        sphere.position = position
        centerEntity.addChild(sphere)
        content.add(centerEntity)
    }
    
    func getRandomSize() -> Float {
        Float.random(in: 0.1...1.0)
    }
    
    func getRandomColor() -> SimpleMaterial.Color {
        [ .red, .green, .blue, .yellow, .orange, ].randomElement()!
    }
    
    func getRandomPosition() -> SIMD3<Float> {
        SIMD3(
            Float.random(in: -5.0...5.0),
            Float.random(in: -5.0...5.0),
            Float.random(in: -5.0...5.0),
        )
    }
    
    func getRandomRotationSpeed() -> Float {
        Float.random(in: 0.5...1.0)
    }
    
    func makeSkybox(_ content: RealityViewContent) async {
        // Skybox
        if let hapiLabTexture = try? await TextureResource(
            named: "nebula"
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
