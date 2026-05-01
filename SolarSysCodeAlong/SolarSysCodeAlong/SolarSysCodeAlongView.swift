//
//  ContentView.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//

// Beginner-02
// 1) Create reusable function to add entity.

import SwiftUI
import RealityKit

struct SolarSysCodeAlongView: View {
    let trackingSession = SpatialTrackingSession()
    
    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
            await setCameraTracking()
            
            addSphere(to: content, size: 0.1, color: .red, position: SIMD3(0, 0, 0))
            
            addSphere(to: content, size: 0.1, color: .blue, position: SIMD3(0, 0, -1))
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
}

#Preview {
    SolarSysCodeAlongView()
}
