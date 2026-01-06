# RealityKit Code Along - Animation without ECS

# Source Branches

`https://github.com/RMIT-Ace/SolarSysCodeAlong`

In this post, we will be working on these branches:

- `02-NotUsingECS`

# What is ECS?

In RealityKit, ECS stands for Entity, Component and System. It is a way to build 3D apps using a specific design. The ECS pattern is all about splitting your 3D app into three distinct parts:

- Entities - these are actors or the core objects, for examples, 3D models, light, sound emitter, etc
- Components - store data. A component defines properties, state, or functionality that can be attached to an entity.
- Systems - Logic engines or funtions that run continuously and apply updates or behaviours to entities.

ECS, as a design pattern, is just a suggestion. Developers are free to use it or come up with their own way to do things. However, to really get what ECS can do, let’s think about building an app without it.

# Animation without ECS

Let's rotating this red block here.

```swift
RealityView { content in
    content.camera = .spatialTracking
    
    let redBox = ModelEntity(
        mesh: .generateBox(size: boxSize),
        materials: [
            SimpleMaterial(
                color: .red.withAlphaComponent(0.2), isMetallic: false
            )
        ]
    )
    redBox.name = "RedBox"
    redBox.transform = Transform(translation: SIMD3(0, 0, depth))
    content.add(redBox)
} 
```

We know that an `Enity` contains `transform` and `rotation`. To rotate an entity, we can update `rotation` within `transform` as below.

```swift
    ...
    let angle: Float = 30 * .pi / 180   // 30 degree
    redBox.transform.rotation = simd_quatf(angle: angle, axis: [0, 1, 0])
```

This rotates our red box around y-axis by 30 degrees. To produce an animation, we will need to make this update repeatedly. To do this, we need 2 things:

1. SwiftUI state to keep track of the rotation angle, and
2. Some kind of loop that runs continuously

```swift
    @State private var redBoxRotation: simd_quatf = .init() // (1)

    var body: some View {
        ...
    }
    .task {
        await foreverRunloop() // (2)
    }
```

Using Swift's asychronous feature, we can implement our run loop as simple as:

```swift
private func foreverRunloop() async {
    let angle: Float = 5 * .pi / 180
    while true {
        try? await Task.sleep(for: .milliseconds(100))
        redBoxRotation *= simd_quatf(angle: angle, axis: [0, 1, 0])
    }
}
```

The above function, once starts, run continuously. It updates `redBoxRotation` by 5 degrees every 100 milliseconds (or 10 times in one second). Now we can update our entity (the red box) using the `update` clause of RealityView.

```swift
 var body: some View {
        RealityView { content in
            content.camera = .spatialTracking
            
            let redBox = ModelEntity(...)
            redBox.name = "RedBox"
            redBox.transform = Transform(translation: SIMD3(0, 0, depth))
            content.add(redBox)
            self.redBoxRotation = redBox.transform.rotation
        } update: { content in
            if let redBox = content.entities.first(where: {$0.name == "RedBox"}) {
                redBox.transform.rotation = redBoxRotation
            }
        }
        .task {
            await foreverRunloop()
        }
 }
```
The `update` clause executes every time a state variable is modified.  In our example, it runs each time we change the `redBoxRotation` state variable.

The complete source code is available from git branch `02-NotUsingECS`. Build and run, you should see a spinning red box as show at the top of this post.

Wasn't so hard, was it?

But!

# Code Smell!

My spidey sense is tingling! The app is running, but I’m not quite feeling it. The code looks like it’s trying to juggle entity, logic and data in a bit of a mess. Can you picture if we had heaps of different entities, each needing its own special animation style? That would mean we’d need extra state variables and animation rules for each one. How do we make sure our `foreverRunloop()` runs smoothly, even when the CPU is under the weather? And, worst case scenario, animating big, complicated objects would make our update routine super complicated and hard to understand and reuse.

In our next post, we’ll explore how ECS can assist us.

Until then, "Stay hungry, Stay Foolish" -- Steve Jobs,

Ace