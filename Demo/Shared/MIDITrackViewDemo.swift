// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI
import MIDITrackView

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
        length: 606,
        height: 200
    )
    public var body: some View {
        VStack {
            MIDITrackView(model: $model, trackColor: Color.cyan, noteColor: Color.blue, note: RoundedRectangle(cornerRadius: 10.0))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MIDITrackViewDemo()
    }
}
