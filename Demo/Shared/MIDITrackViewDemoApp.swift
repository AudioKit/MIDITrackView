// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI

@main
struct MIDITrackViewDemoApp: App {
    var body: some Scene {
        WindowGroup {
            MIDITrackViewDemo(conductor: Conductor())
        }
    }
}
