//
//  SolarSysViewModel.swift
//  OrbitAnimationStudy
//
//  Created by Ace on 9/9/2025.
//

import Foundation
import RealityKit
import SolarSysRealityKit

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
                            rotationSpeed: 0.5,
                            orbitalSpeed: 2.5,
                        )
                    ]
                ),
                CelestialObject(
                    name: "Mars",
                    scale: 0.9,
                    distanceCenter: 1.8,
                    rotationSpeed: 2.0,
                    orbitalSpeed: 8.0
                ),
                CelestialObject(
                    name: "Jupiter",
                    scale: 3.0,
                    distanceCenter: 4.0,
                    rotationSpeed: 2.0,
                    orbitalSpeed: 10.0
                )
            ]
        )
    ]
    
    func setupCelestialSystem(
        for parent: CelestialEntity,
        celestialObj: CelestialObject? = nil
    ) async {
        guard let celestialObj = celestialObj ?? celestialObjects.first
        else { return }
        guard let newCelestialEntity = await CelestialEntity(
            bundle: SolarSysRealityKitResources.bundle,
            name: celestialObj.name,
            scale: celestialObj.scale,
            distanceFromCenter: celestialObj.distanceCenter
        )  else {
            print(">> WARN: Could not create model for \(celestialObj.name)")
            return
        }
        parent.addChild(newCelestialEntity)
        for child in celestialObj.satellites {
            await setupCelestialSystem(
                for: newCelestialEntity,
                celestialObj: child
            )
        }
    }
    
    func updateCelestialMovements(
        in parent: CelestialEntity,
        for celestialObj: CelestialObject?,
        standardSpeed: Float
    ) async {
        guard let celestialObj = celestialObj ?? celestialObjects.first
        else { return }
        guard let celestialEntity = parent.findEntity(named: celestialObj.name) as? CelestialEntity else {
            print(">> WARN: Could not find model for \(celestialObj.name)")
            return
        }
        await celestialEntity.updateRotation(speed: standardSpeed / celestialObj.rotationSpeed)
        await celestialEntity.updateOrbit(speed: standardSpeed / celestialObj.orbitalSpeed)
        for child in celestialObj.satellites {
            await updateCelestialMovements(in: celestialEntity, for: child, standardSpeed: standardSpeed)
        }
    }
}
