//
//  ContentView.swift
//  SolarSysCodeAlong
//
//  Created by Ace on 15/9/2025.
//

import SwiftUI
import RealityKit

struct SolarSysCodeAlongView: View {
    var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SolarSysCodeAlongView()
}
