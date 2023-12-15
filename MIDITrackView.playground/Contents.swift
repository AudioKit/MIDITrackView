import MIDITrackView
import PlaygroundSupport
import SwiftUI

struct MIDITrackViewDemo: View {
    @State var model = MIDITrackViewModel(
        midiNotes: [
            CGRect(x: 0.5, y: 0.0, width: 1.0, height: 10.0),
            CGRect(x: 1.0, y: 20.0, width: 1.0, height: 10.0),
            CGRect(x: 1.5, y: 40.0, width: 5.0, height: 10.0)
        ],
        length: 500,
        height: 200,
        playPos: 0.0,
        zoomLevel: 50.0,
        minimumZoom: 0.01,
        maximumZoom: 1000.0
    )
    public var body: some View {
        VStack {
            MIDITrackView(model: $model, trackColor: Color.cyan, noteColor: Color.blue)
        }
    }
}

PlaygroundPage.current.setLiveView(MIDITrackViewDemo().frame(width: 500, height: 500))
PlaygroundPage.current.needsIndefiniteExecution = true
