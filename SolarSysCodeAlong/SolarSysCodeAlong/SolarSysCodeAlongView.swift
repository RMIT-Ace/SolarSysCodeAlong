//
//  ContentView.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//

// Beginner-00
// 1) Basic minimum RealityKit app

import SwiftUI
import RealityKit

struct SolarSysCodeAlongView: View {
    let trackingSession = SpatialTrackingSession()
    
    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
            await setCameraTracking()
            
            
            
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
}

#Preview {
    SolarSysCodeAlongView()
}
