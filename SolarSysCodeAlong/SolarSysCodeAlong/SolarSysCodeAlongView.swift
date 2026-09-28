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
            await turnOnCameraTracking(for: &content)
            addRandomSphere(to: content, numOfSpheres: 20)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SolarSysCodeAlongView()
}
