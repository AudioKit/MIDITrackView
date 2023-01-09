// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI
import MIDITrackView

struct MIDITrackViewDemo: View {
    @State var model: MIDITrackViewModel

    public init(midiNotes: [MIDITrackViewNote] = [], height: CGFloat = 0.0) {
        self.model = MIDITrackViewModel(
            midiNotes: midiNotes,
            length: 10000,
            height: height
        )
    }
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
