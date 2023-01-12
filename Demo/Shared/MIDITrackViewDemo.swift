// Copyright AudioKit. All Rights Reserved. Revision History at http://github.com/AudioKit/MIDITrackView/

import SwiftUI
import MIDITrackView

struct MIDITrackViewDemo: View {
    @EnvironmentObject var model: MIDITrackViewModel

    public var body: some View {
        VStack {
            MIDITrackView(trackColor: Color.cyan, noteColor: Color.blue, note: RoundedRectangle(cornerRadius: 10.0))
                .environmentObject(model)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MIDITrackViewDemo()
    }
}
