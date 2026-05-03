//
//  ContentView.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//

// Beginner-04
// 1) Make them move!

import SwiftUI
import RealityKit

struct SolarSysCodeAlongView: View {
    let trackingSession = SpatialTrackingSession()
    
    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
            await setCameraTracking()
            
            for _ in 0..<20 {
                addSphere(
                    to: content,
                    size: getRandomSize(),
                    color: getRandomColor(),
                    position: getRandomPosition()
                )
            }
        }
        .onAppear { RotationSystem.registerSystem() }
        .ignoresSafeArea()
    }
    
    func setCameraTracking() async {
        let config = SpatialTrackingSession.Configuration(
            tracking: [.camera, .world, .plane, .object, .image],
            sceneUnderstanding: [.shadow, .collision, .physics],
            camera: .back
        )
        await trackingSession.run(config)
    }
    
    func addSphere(
        to content: RealityViewCameraContent,
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
            Float.random(in: -3.0...3.0),
            Float.random(in: -3.0...3.0),
            Float.random(in: -3.0...3.0),
        )
    }
    
    func getRandomRotationSpeed() -> Float {
        Float.random(in: 1.0...3.0)
    }
}

#Preview {
    SolarSysCodeAlongView()
}
