import MIDITrackView
import PlaygroundSupport
import SwiftUI

struct MIDITrackViewDemo: View {
    @State var model = MIDITrackViewModel(
        midiNotes: [
            MIDINote(position: 80, level: 5, length: 102, height: 5),
            MIDINote(position: 103, level: 23, length: 75, height: 5),
            MIDINote(position: 157, level: 36, length: 25, height: 5),
            MIDINote(position: 208, level: 5, length: 102, height: 5),
            MIDINote(position: 301, level: 23, length: 75, height: 5),
            MIDINote(position: 376, level: 36, length: 25, height: 5),
            MIDINote(position: 402, level: 5, length: 102, height: 5),
            MIDINote(position: 450, level: 23, length: 75, height: 5),
            MIDINote(position: 500, level: 36, length: 25, height: 5)
        ],
        length: 500,
        height: 200
    )
    public var body: some View {
        VStack {
            MIDITrackView(model: $model, trackColor: Color.cyan, noteColor: Color.blue)
        }
    }
}

PlaygroundPage.current.setLiveView(MIDITrackViewDemo().frame(width: 500, height: 500))
PlaygroundPage.current.needsIndefiniteExecution = true
