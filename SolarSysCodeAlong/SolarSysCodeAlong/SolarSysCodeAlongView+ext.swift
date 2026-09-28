//
//  SolarSysCodeAlongView+ext.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 28/9/2026.
//

import SwiftUI
import RealityKit

extension SolarSysCodeAlongView {

    func turnOnCameraTracking(
        for content: inout RealityViewCameraContent
    ) async {
        let config = SpatialTrackingSession.Configuration(
            tracking: [.camera, .world, .plane, .object, .image],
            sceneUnderstanding: [.shadow, .collision, .physics],
            camera: .back
        )
        content.camera = .spatialTracking
        await trackingSession.run(config)
    }
    
    func addRandomSphere(
        to content: RealityViewCameraContent,
        numOfSpheres: Int = 10
    ) {
        for _ in 0..<numOfSpheres {
            addSphere(
                to: content,
                size: getRandomSize(),
                color: getRandomColor(),
                position: getRandomPosition()
            )
        }
    }

    func addSphere(
        to content: RealityViewCameraContent,
        size: Float,
        color: SimpleMaterial.Color,
        position: SIMD3<Float>
    ) {
        let centerEntity = Entity()
        RotationSystem.registerSystem() // Register on first call. Ignore on all subsequent calls.
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
        Float.random(in: 0.5...1.0)
    }

}
