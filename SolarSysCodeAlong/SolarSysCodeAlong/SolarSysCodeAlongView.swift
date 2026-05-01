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
    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
            
            addSphere(to: content, size: 0.1, color: .red, position: SIMD3(0, 0, 0))
            
            addSphere(to: content, size: 0.1, color: .blue, position: SIMD3(0, 0, -1))
        }
        .ignoresSafeArea()
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
