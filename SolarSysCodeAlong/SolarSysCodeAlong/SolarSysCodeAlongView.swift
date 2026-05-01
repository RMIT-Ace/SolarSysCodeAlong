//
//  ContentView.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//

// Beginner-03
// 1) Programmatically create random sphere in the room

import SwiftUI
import RealityKit

struct SolarSysCodeAlongView: View {
    let trackingSession = SpatialTrackingSession()
    
    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
            await setCameraTracking()
            
            for _ in 0..<10 {
                addSphere(
                    to: content,
                    size: getRandomSize(),
                    color: getRandomColor(),
                    position: getRandomPosition()
                )
            }
        }
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
        let sphere = ModelEntity(
            mesh: .generateSphere(radius: size / 2.0),
            materials: [SimpleMaterial(color: color, isMetallic: true)]
        )
        sphere.position = position
        content.add(sphere)
    }
    
    func getRandomSize() -> Float {
        Float.random(in: 0.1...1.0)
    }
    
    func getRandomColor() -> SimpleMaterial.Color {
        [ .red, .green, .blue, .yellow, .orange, ].randomElement()!
    }
    
    func getRandomPosition() -> SIMD3<Float> {
        SIMD3(
            Float.random(in: -2.0...2.0),
            Float.random(in: -2.0...2.0),
            Float.random(in: -2.0...2.0),
        )
    }
}

#Preview {
    SolarSysCodeAlongView()
}
