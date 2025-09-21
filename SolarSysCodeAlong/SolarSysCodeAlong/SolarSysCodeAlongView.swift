//
//  ContentView.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//
//  Notes:
//  (1) Minimum project structure for RealityKit app.
//  (2) SwiftUI component - RealityView
//  (3) Camera tracking - mapping virtual entities into realworld.
//  (4) Expand our view on entire display areas.
//
//  Exercises:
//  (E1) Build and deploy to device
//  (E2) Comment out camera tracking (3)
//  (E3) Comment out ignore safe area (4)

import SwiftUI
import RealityKit

struct SolarSysCodeAlongView: View {                // (1)
    var body: some View {
        RealityView { content in                    // (2)
            content.camera = .spatialTracking       // (3)
        }
        .ignoresSafeArea()                          // (4)
    }
}

#Preview {
    SolarSysCodeAlongView()
}
