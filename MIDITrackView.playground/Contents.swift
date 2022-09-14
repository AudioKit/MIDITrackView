import MIDITrackView
import PlaygroundSupport
import SwiftUI

struct MIDITrackViewDemo: View {
    public var body: some View {
        VStack {
            MIDITrackView()
        }
    }
}

PlaygroundPage.current.setLiveView(MIDITrackViewDemo().frame(width: 500, height: 500))
PlaygroundPage.current.needsIndefiniteExecution = true
