// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "MIDITrackView",
    platforms: [.macOS(.v12), .iOS(.v15)],
    products: [.library(name: "MIDITrackView", targets: ["MIDITrackView"])],
    targets: [
        .target(name: "MIDITrackView", dependencies: []),
        .testTarget(name: "MIDITrackViewTests", dependencies: ["MIDITrackView"]),
    ]
)
