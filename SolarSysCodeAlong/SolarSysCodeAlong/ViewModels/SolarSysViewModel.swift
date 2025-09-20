//
//  SolarSysViewModel.swift
//  OrbitAnimationStudy
//
//  Created by Ace on 9/9/2025.
//

import Foundation

@Observable
class SolarSysViewModel {
    
    let celestialObjects: [CelestialObject] = [
        CelestialObject(
            name: "Sun",
            scale: 3.0,
            distanceCenter: 0.0,
            rotationSpeed: 27.0,
            orbitalSpeed: 0.0,
            satellites: [
                CelestialObject(
                    name: "Earth",
                    scale: 1.0,
                    distanceCenter: 1.0,
                    rotationSpeed: 3.0,
                    orbitalSpeed: 10.0,
                    satellites: [
                        CelestialObject(
                            name: "Moon",
                            scale: 1.0 / 2.0,
                            distanceCenter: 0.2,
                            rotationSpeed: 2.0,
                            orbitalSpeed: 1.0,
                        )
                    ]
                ),
            ]
        )
    ]
}
